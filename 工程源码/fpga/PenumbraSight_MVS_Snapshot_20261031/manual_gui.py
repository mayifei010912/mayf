"""File picker for the same validated ARM+FPGA snapshot pipeline.

Opening this window never touches hardware; only the explicit Start button
launches app.py --manual. That worker processes only the chosen RAW, then exits.
"""
from pathlib import Path
import json,os,sys,subprocess,time,uuid,webbrowser,re,msvcrt
import tkinter as tk
from tkinter import ttk,filedialog,messagebox
from PIL import Image,ImageTk
from app import validate_raw,write
import reset_control
from status_io import read_text as read_shared_text
ROOT=Path(__file__).resolve().parent

def worker_running():
 with (ROOT/'watcher.lock').open('a+b') as f:
  f.seek(0)
  try:msvcrt.locking(f.fileno(),msvcrt.LK_NBLCK,1)
  except OSError:return True
  f.seek(0);msvcrt.locking(f.fileno(),msvcrt.LK_UNLCK,1)
 return False

class Window:
 def __init__(self,root):
  self.root=root;self.process=None;self.request=None;self.job=None;self.images={};self.image_paths={};self.reset_id=None
  root.title('选取RAW → FPGA重构');root.geometry('1050x790');root.minsize(930,690)
  self.path=tk.StringVar();self.status=tk.StringVar(value='先选择MVS保存的RAW，再点击“开始FPGA重构”。')
  self.detail=tk.StringVar(value='仅打开本窗口不会初始化板子，也不会提交照片。')
  outer=ttk.Frame(root,padding=20);outer.pack(fill='both',expand=True)
  ttk.Label(outer,text='选取抓拍照片，交给FPGA重构',font=('Microsoft YaHei UI',18,'bold')).pack(anchor='w')
  cfg=json.loads((ROOT/'config.json').read_text(encoding='utf-8'))
  ttk.Label(outer,text='当前参考耗时约%.1f分钟 · ARM调度＋FPGA计算 · 每通道上限1100次'%(cfg.get('reference_rgb_seconds',682.814892334)/60),font=('Microsoft YaHei UI',10)).pack(anchor='w',pady=(8,3))
  ttk.Label(outer,text='输入要求：5472×3648 BayerGB12 RAW，非Packed，每像素16位；固定场景及标定。',wraplength=990).pack(anchor='w')
  row=ttk.Frame(outer);row.pack(fill='x',pady=(16,8))
  ttk.Entry(row,textvariable=self.path,state='readonly').pack(side='left',fill='x',expand=True,padx=(0,10))
  self.choose_button=ttk.Button(row,text='选择RAW文件…',command=self.choose);self.choose_button.pack(side='right')
  buttons=ttk.Frame(outer);buttons.pack(fill='x',pady=5)
  self.start_button=ttk.Button(buttons,text='开始FPGA重构',command=self.start);self.start_button.pack(side='left')
  self.reset_button=ttk.Button(buttons,text='停止并重置',command=self.reset);self.reset_button.pack(side='left',padx=10)
  ttk.Button(buttons,text='查看进度页',command=self.progress_page).pack(side='left',padx=10)
  ttk.Button(buttons,text='查看运行日志',command=self.log).pack(side='left')
  ttk.Label(outer,textvariable=self.status,font=('Microsoft YaHei UI',12,'bold'),wraplength=990).pack(anchor='w',pady=(16,5))
  ttk.Label(outer,textvariable=self.detail,wraplength=990).pack(anchor='w')
  panels=ttk.Frame(outer);panels.pack(fill='both',expand=True,pady=15)
  self.preview={}
  for i,(name,title) in enumerate([('wall_preview.png','相机墙面采样区（预览提亮）'),('reconstruction.png','FPGA重构结果')]):
   panel=ttk.LabelFrame(panels,text=title,padding=8);panel.grid(row=0,column=i,sticky='nsew',padx=(0,8) if i==0 else (8,0))
   panels.columnconfigure(i,weight=1,uniform='images')
   label=ttk.Label(panel,text='提交后显示',anchor='center');label.pack(fill='both',expand=True);self.preview[name]=label
  panels.rowconfigure(0,weight=1)
  bottom=ttk.Frame(outer);bottom.pack(fill='x')
  self.result_button=ttk.Button(bottom,text='打开最终重构图',command=self.open_result,state='disabled');self.result_button.pack(side='left')
  self.folder_button=ttk.Button(bottom,text='打开本次结果文件夹',command=self.open_folder,state='disabled');self.folder_button.pack(side='left',padx=10)
  ttk.Label(outer,text='停止并重置会取消当前计算、清除待处理队列；RAW和已完成结果保留。关闭窗口不会取消计算。',wraplength=990).pack(anchor='w',pady=(12,0))
  ttk.Label(outer,text='自动版与选图版请择一运行；本功能不会读取或修改手机上播放的原图。',wraplength=990).pack(anchor='w',pady=(4,0))
  self.recover();root.after(500,self.poll)
 def choose(self):
  selected=filedialog.askopenfilename(title='选择MVS原始抓拍RAW',initialdir=str(ROOT/'captures'),filetypes=[('MVS RAW文件','*.raw')])
  if not selected:return
  try:validate_raw(selected)
  except Exception as e:messagebox.showerror('文件不符合输入要求',str(e));return
  self.request=None;self.job=None;self.images.clear();self.image_paths.clear()
  for label in self.preview.values():label.configure(image='',text='提交后显示')
  self.result_button.configure(state='disabled');self.folder_button.configure(state='disabled')
  self.path.set(selected);self.status.set('已选择照片，点击“开始FPGA重构”提交。')
  self.detail.set('39,923,712字节 · 重新选择同一张RAW也可新建一次计算任务。')
 def start(self):
  created=None
  try:
   path=validate_raw(self.path.get())
   if worker_running():raise RuntimeError('已有处理任务在运行。请在自动版点击“停止监听”并等待当前张完成，或等另一选图任务结束后再提交。本次尚未提交。')
   ident=uuid.uuid4().hex;folder=ROOT/'manual_requests';folder.mkdir(exist_ok=True)
   self.request=folder/(ident+'.json');created=self.request;write(self.request,dict(phase='STARTING',source_path=str(path),created=time.strftime('%Y-%m-%d %H:%M:%S')))
   logfile=folder/(ident+'.log')
   with logfile.open('w',encoding='utf-8') as log:
    python=Path(sys.executable).with_name('python.exe')
    self.process=subprocess.Popen([str(python),'-u',str(ROOT/'app.py'),'--manual','--submit',str(path),'--manual-request',ident,'--no-browser'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
   self.job=None;self.images.clear();self.image_paths.clear()
   for label in self.preview.values():label.configure(image='',text='等待计算数据…')
   self.choose_button.configure(state='disabled');self.start_button.configure(state='disabled')
   self.result_button.configure(state='disabled');self.folder_button.configure(state='disabled')
   self.status.set('正在启动选图任务…');self.detail.set('即将检查串口、驱动和已验证的新FPGA配置。')
  except Exception as e:
   if created:write(created,dict(phase='FAILED',source_path=self.path.get(),error=str(e)))
   messagebox.showerror('未能提交',str(e))
 def recover(self):
  folder=ROOT/'manual_requests'
  if not folder.exists():return
  for p in sorted(folder.glob('*.json'),key=lambda x:x.stat().st_mtime,reverse=True):
   try:s=json.loads(read_shared_text(p))
   except (OSError,ValueError):continue
   if s.get('phase')=='CANCELLED':self.status.set('上次任务已取消，可重新选择RAW。');return
   if s.get('phase') in ('STARTING','INITIALIZING','RUNNING') and worker_running():
    self.request=p;self.path.set(s.get('source_path',''))
    self.choose_button.configure(state='disabled');self.start_button.configure(state='disabled');return
   if s.get('phase')=='DONE':
    self.request=p;self.path.set(s.get('source_path',''));return
 def load_preview(self,name):
  path=self.job/name
  if not path.exists():return
  stamp=path.stat().st_mtime_ns
  if self.image_paths.get(name)==stamp:return
  with Image.open(path) as source:
   im=source.convert('RGB');scale=min(450/im.width,350/im.height)
   im=im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.NEAREST)
  self.images[name]=ImageTk.PhotoImage(im);self.image_paths[name]=stamp
  self.preview[name].configure(image=self.images[name],text='')
 def poll(self):
  if self.poll_reset():self.root.after(1000,self.poll);return
  try:
   if self.request and self.request.exists():
    s=json.loads(read_shared_text(self.request));phase=s.get('phase')
    if s.get('job_id'):
     self.job=ROOT/'jobs'/s['job_id'];self.folder_button.configure(state='normal')
     for name in self.preview:self.load_preview(name)
    if phase in ('STARTING','INITIALIZING'):
     self.status.set('正在检查开发板并准备计算配置…')
     self.detail.set('需要板子供电、PS_UART和JTAG；关闭MobaXterm的COM标签。相机可以不接。')
    elif phase=='RUNNING' and self.job:
     p=self.job/'progress.json'
     st=json.loads(read_shared_text(p)) if p.exists() else {}
     local=json.loads(read_shared_text(self.job/'status.json'))
     if local.get('phase')=='PREPROCESSING':self.status.set('正在解码RAW并生成本张照片的测量数据…')
     else:
      channel=st.get('channel',0)+1;match=re.search(r'ITERATION (\d+)',st.get('last_progress',''))
      self.status.set('FPGA正在计算：通道 %d/3%s'%(channel,('，迭代 '+match[1]+'/1100') if match else ''))
     self.detail.set('结果目录：'+str(self.job)+'；不同照片耗时可能变化。')
    elif phase=='DONE':
     report=json.loads((self.job/'result_report.json').read_text(encoding='utf-8'))
     self.status.set('重构完成，用时 %.1f分钟。'%(report['seconds']/60))
     note='达到迭代上限，未判定收敛。' if not all(c['converged'] for c in report['channels']) else '满足停止条件。'
     self.detail.set(note+' 最终图片：'+str(self.job/'reconstruction.png'))
     self.result_button.configure(state='normal');self.choose_button.configure(state='normal');self.start_button.configure(state='normal')
    elif phase=='FAILED':
     self.status.set('本次任务未完成：'+s.get('error','请查看日志'))
     self.detail.set('请先处理错误。已提交的板端任务请用原自动入口恢复查看，勿反复提交。')
     self.choose_button.configure(state='normal');self.start_button.configure(state='normal')
    elif phase=='CANCELLED':self.clear_view();self.status.set('已停止并重置，可重新选择RAW。')
    if self.process and self.process.poll() is not None and phase not in ('DONE','FAILED','CANCELLED'):
     self.status.set('后台程序已退出，请查看运行日志。')
     self.choose_button.configure(state='normal');self.start_button.configure(state='normal')
  except (OSError,ValueError,KeyError):pass
  self.root.after(1000,self.poll)
 def clear_view(self):
  self.request=None;self.job=None;self.images.clear();self.image_paths.clear()
  if hasattr(self,'path'):self.path.set('')
  if hasattr(self,'current_job_id'):self.current_job_id=None
  for label in self.preview.values():label.configure(image='',text='等待新任务…')
  self.result_button.configure(state='disabled');self.folder_button.configure(state='disabled')
  if hasattr(self,'choose_button'):self.choose_button.configure(state='normal')
  self.start_button.configure(state='normal')
  if hasattr(self,'set_bar'):self.set_bar('determinate')
 def reset(self):
  try:
   self.reset_id=reset_control.request_reset();self.reset_button.configure(state='disabled')
   self.status.set('已请求停止并重置，正在等待安全点…')
   self.detail.set('不删除原始RAW和已完成的结果；正在停止的任务不会自动重跑。')
  except Exception as e:messagebox.showerror('未能重置',str(e))
 def poll_reset(self):
  if not self.reset_id:return False
  data=reset_control.read(ROOT/'reset_status.json')
  if data.get('request_id')!=self.reset_id:return False
  phase=data.get('phase')
  self.status.set(data.get('message','正在停止并重置…'))
  if phase in ('REQUESTED','RESETTING'):
   self.start_button.configure(state='disabled');self.reset_button.configure(state='disabled')
   if hasattr(self,'choose_button'):self.choose_button.configure(state='disabled')
   return True
  if phase=='RESETTED':
   self.clear_view();self.detail.set('RAW和已完成结果均保留。可以重新开始新任务。')
   self.reset_id=None;self.reset_button.configure(state='normal');return True
  if phase=='RESET_FAILED':
   self.detail.set('重置尚未确认，请检查串口/日志后再次点击“停止并重置”。')
   self.reset_id=None;self.reset_button.configure(state='normal');return True
  return False
 def open_result(self):
  if self.job and (self.job/'reconstruction.png').exists():os.startfile(str(self.job/'reconstruction.png'))
 def open_folder(self):
  if self.job and self.job.exists():os.startfile(str(self.job))
 def progress_page(self):
  if worker_running():
   port=json.loads((ROOT/'config.json').read_text())['dashboard_port'];webbrowser.open('http://127.0.0.1:%d/status.html'%port)
  elif (ROOT/'status.html').exists():os.startfile(str(ROOT/'status.html'))
 def log(self):
  path=self.request.with_suffix('.log') if self.request else ROOT/'watcher.log'
  if path.exists():os.startfile(str(path))
  else:messagebox.showinfo('运行日志','尚未提交选图任务。')

if __name__=='__main__':
 try:
  root=tk.Tk();root.option_add('*Font',('Microsoft YaHei UI',10));Window(root);root.mainloop()
 except Exception:
  import traceback
  text=traceback.format_exc();(ROOT/'manual_gui_errors.log').write_text(text,encoding='utf-8')
  try:messagebox.showerror('选图窗口启动失败','请查看F盘程序目录的manual_gui_errors.log。')
  except Exception:pass
  raise

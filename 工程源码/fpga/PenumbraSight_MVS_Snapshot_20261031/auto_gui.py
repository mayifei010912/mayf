"""Native automatic-capture UI; the existing app.py owns all FPGA operations."""
from pathlib import Path
import json,os,sys,subprocess,re,time
import tkinter as tk
from tkinter import ttk,messagebox
from manual_gui import Window as PreviewWindow,worker_running
from app import write
from status_io import read_text as read_shared_text
ROOT=Path(__file__).resolve().parent

def read_runtime():
 try:return json.loads(read_shared_text(ROOT/'ui_status.json'))
 except (OSError,ValueError):return {}

def stopping(data):
 if data.get('stop_requested'):return True
 try:return bool(data.get('run_id')) and json.loads(read_shared_text(ROOT/'auto_stop.json')).get('run_id')==data['run_id']
 except (OSError,ValueError):return False

class Window(PreviewWindow):
 def __init__(self,root):
  self.root=root;self.process=None;self.request=None;self.job=None;self.images={};self.image_paths={};self.bar_mode=None
  self.current_job_id=None;self.launched_pid=None;self.reset_id=None;self.seen_reset=None
  root.title('自动抓拍 → FPGA重构');root.geometry('1070x850');root.minsize(950,760)
  self.status=tk.StringVar(value='未开始监听。准备好设备后，点击“开始监听”。')
  self.detail=tk.StringVar(value='然后在MVS点击一次抓图；RAW保存完成后会自动进入FPGA重构。')
  self.queue_text=tk.StringVar(value='排队：0张')
  outer=ttk.Frame(root,padding=20);outer.pack(fill='both',expand=True)
  ttk.Label(outer,text='MVS自动抓拍 → FPGA重构',font=('Microsoft YaHei UI',18,'bold')).pack(anchor='w')
  ttk.Label(outer,text='抓拍一次，自动处理并返回重构图。',font=('Microsoft YaHei UI',11)).pack(anchor='w',pady=(6,3))
  cfg=json.loads((ROOT/'config.json').read_text(encoding='utf-8'))
  ttk.Label(outer,text='已使用提速版 · 板端参考约%.1f分钟 · 每通道上限1100次 · 相机参数与场景沿用现有标定'%(cfg['reference_rgb_seconds']/60),wraplength=1020).pack(anchor='w')
  row=ttk.Frame(outer);row.pack(fill='x',pady=(15,8))
  ttk.Label(row,text='MVS保存目录：').pack(side='left')
  self.capture_path=tk.StringVar(value=str(ROOT/'captures'))
  ttk.Entry(row,textvariable=self.capture_path,state='readonly').pack(side='left',fill='x',expand=True,padx=(0,10))
  ttk.Button(row,text='打开抓拍目录',command=self.open_captures).pack(side='right')
  buttons=ttk.Frame(outer);buttons.pack(fill='x',pady=4)
  self.start_button=ttk.Button(buttons,text='开始监听',command=self.start);self.start_button.pack(side='left')
  self.stop_button=ttk.Button(buttons,text='停止监听（完成当前张）',command=self.stop,state='disabled');self.stop_button.pack(side='left',padx=10)
  self.reset_button=ttk.Button(buttons,text='停止并重置',command=self.reset);self.reset_button.pack(side='left',padx=(0,10))
  ttk.Button(buttons,text='打开MVS',command=self.open_mvs).pack(side='left')
  ttk.Button(buttons,text='查看运行日志',command=self.log).pack(side='left',padx=10)
  ttk.Label(outer,textvariable=self.status,font=('Microsoft YaHei UI',12,'bold'),wraplength=1020).pack(anchor='w',pady=(15,6))
  progress=ttk.Frame(outer);progress.pack(fill='x')
  self.bar=ttk.Progressbar(progress,mode='determinate',maximum=3300);self.bar.pack(side='left',fill='x',expand=True,padx=(0,12))
  ttk.Label(progress,textvariable=self.queue_text).pack(side='right')
  ttk.Label(outer,textvariable=self.detail,wraplength=1020).pack(anchor='w',pady=(7,0))
  panels=ttk.Frame(outer);panels.pack(fill='both',expand=True,pady=14);panels.rowconfigure(0,weight=1)
  self.preview={}
  for i,(name,title) in enumerate([('wall_preview.png','本张墙面采样区（预览提亮）'),('reconstruction.png','本张FPGA重构结果')]):
   panel=ttk.LabelFrame(panels,text=title,padding=8);panel.grid(row=0,column=i,sticky='nsew',padx=(0,8) if i==0 else (8,0));panels.columnconfigure(i,weight=1,uniform='panels')
   label=ttk.Label(panel,text='新照片处理后显示',anchor='center');label.pack(fill='both',expand=True);self.preview[name]=label
  bottom=ttk.Frame(outer);bottom.pack(fill='x')
  self.result_button=ttk.Button(bottom,text='打开最终重构图',command=self.open_result,state='disabled');self.result_button.pack(side='left')
  self.folder_button=ttk.Button(bottom,text='打开本次结果文件夹',command=self.open_folder,state='disabled');self.folder_button.pack(side='left',padx=10)
  ttk.Button(bottom,text='打开全部结果目录',command=lambda:os.startfile(str(ROOT/'jobs'))).pack(side='left')
  ttk.Label(outer,text='输入：5472×3648 BayerGB12非Packed RAW。监听目录中的未处理照片会进入队列，每次只计算一张。',wraplength=1020).pack(anchor='w',pady=(10,0))
  ttk.Label(outer,text='停止监听：完成当前张再退出。停止并重置：中止当前任务并清空队列，保留RAW和已完成结果。',wraplength=1020).pack(anchor='w',pady=(4,0))
  completed=sorted((ROOT/'jobs').glob('*/reconstruction.png'))
  if completed:
   self.set_job(completed[-1].parent.name)
   self.detail.set('显示上次保存的结果；尚未启动新的计算。')
  root.after(500,self.poll)
 def set_bar(self,mode,value=0,maximum=3300):
  if self.bar_mode!=mode:
   self.bar.stop();self.bar.configure(mode=mode);self.bar_mode=mode
   if mode=='indeterminate':self.bar.start(15)
  if mode=='determinate':self.bar.configure(value=value,maximum=maximum)
 def set_job(self,ident):
  if ident!=self.current_job_id:
   self.job=ROOT/'jobs'/ident;self.current_job_id=ident;self.images.clear();self.image_paths.clear()
   for label in self.preview.values():label.configure(image='',text='等待本张数据…')
  for name in self.preview:self.load_preview(name)
  self.result_button.configure(state='normal' if (self.job/'reconstruction.png').exists() else 'disabled')
  self.folder_button.configure(state='normal' if self.job.exists() else 'disabled')
 def start(self):
  try:
   if worker_running():
    data=read_runtime()
    if data.get('mode')=='manual':raise RuntimeError('手动选图任务正在使用FPGA，请等它完成后再开始自动监听。')
    self.status.set('已有处理服务正在运行，正在连接其状态。');return
   if self.process and self.process.poll() is None:return
   with (ROOT/'auto_backend.log').open('a',encoding='utf-8') as log:
    python=Path(sys.executable).with_name('python.exe')
    self.process=subprocess.Popen([str(python),'-u',str(ROOT/'app.py'),'--no-browser'],cwd=ROOT,stdout=log,stderr=subprocess.STDOUT,creationflags=subprocess.CREATE_NO_WINDOW)
   self.launched_pid=self.process.pid;self.start_button.configure(state='disabled')
   self.status.set('正在启动监听服务并检查开发板…');self.detail.set('需要板子供电、PS_UART和JTAG；关闭MobaXterm的COM标签。')
   self.set_bar('indeterminate')
  except Exception as e:messagebox.showerror('未能开始监听',str(e))
 def stop(self):
  data=read_runtime()
  if not worker_running():self.status.set('当前没有运行中的监听服务。');return
  if data.get('mode')!='automatic' or not data.get('run_id'):
   messagebox.showinfo('无法在此停止','当前可能是选图任务或旧命令窗口。请等待任务完成；旧命令版可在其窗口按Ctrl+C。');return
  write(ROOT/'auto_stop.json',{'run_id':data['run_id'],'requested_at':time.time()})
  self.stop_button.configure(state='disabled');self.status.set('已请求停止监听；当前这一张会继续完成并保存。')
 def poll(self):
  if self.poll_reset():self.root.after(1000,self.poll);return
  try:
   data=read_runtime();running=worker_running();starting=self.process is not None and self.process.poll() is None
   if starting and data.get('pid')!=self.launched_pid:
    self.root.after(1000,self.poll);return
   self.start_button.configure(state='disabled' if running or starting else 'normal')
   auto=running and data.get('mode')=='automatic'
   self.stop_button.configure(state='normal' if auto and not stopping(data) else 'disabled')
   self.queue_text.set('排队：%d张'%data.get('queue_count',0))
   if data.get('job_id'):self.set_job(data['job_id'])
   phase=data.get('phase')
   if phase=='RESETTED' and self.seen_reset!=data.get('reset_request_id'):
    self.clear_view();self.seen_reset=data.get('reset_request_id')
   if running:
    if data.get('mode')=='manual':
     self.status.set('当前是手动选图任务；完成后可开始自动监听。');self.set_bar('indeterminate')
    elif phase=='INITIALIZING':
     self.status.set('正在检查开发板并准备已验证的计算配置…');self.set_bar('indeterminate')
    elif phase=='WAITING':
     self.status.set('正在监听：请在MVS点击一次抓图。');self.set_bar('determinate')
    elif phase=='PREPROCESSING':
     self.status.set('检测到新抓拍，正在解码RAW并生成测量数据…');self.set_bar('indeterminate')
    elif phase=='COMPUTING':
     c=data.get('channel',0);cap=data.get('iteration_cap',1100);m=re.search(r'ITERATION (\d+)',data.get('last_progress',''));it=int(m[1]) if m else 0
     self.status.set('FPGA正在计算：通道 %d/3，迭代 %d/%d'%(c+1,it,cap));self.set_bar('determinate',c*cap+it,3*cap)
    elif phase=='DONE':
     self.status.set(data.get('message','本张重构已完成。'));self.set_bar('determinate',3300)
    elif phase in ('FAILED','RESET_FAILED'):self.status.set(data.get('message','服务遇到错误，请查看运行日志。'));self.set_bar('determinate')
    else:self.status.set(data.get('message','正在读取服务状态…'))
    if stopping(data):self.status.set('已请求停止；当前张处理完后退出，后续排队任务保留。')
    if self.job:
     capture=self.job/'capture.json';source=json.loads(capture.read_text(encoding='utf-8')).get('source_path','') if capture.exists() else ''
     self.detail.set('本张：'+Path(source).name+'  |  结果目录：'+str(self.job))
    else:self.detail.set('MVS保存到上方目录，RAW写完后会自动处理。')
   else:
    self.stop_button.configure(state='disabled');self.set_bar('determinate')
    if phase in ('FAILED','RESET_FAILED'):self.status.set(data.get('message','处理已停止，请查看日志。'))
    elif phase=='RESETTED':self.status.set('已停止并重置，可点击“开始监听”重新开始。')
    elif phase=='STOPPED':self.status.set('监听已停止；可点击“开始监听”继续。')
    elif phase=='DONE' and self.job:self.status.set('上一张已完成；当前未开始自动监听。')
    elif self.process and self.process.poll() not in (None,0):self.status.set('后台程序已退出，请查看运行日志后重试。')
    else:self.status.set('未开始监听。准备好设备后，点击“开始监听”。')
   if self.job and (self.job/'result_report.json').exists() and phase in ('DONE','WAITING','STOPPED'):
    report=json.loads((self.job/'result_report.json').read_text(encoding='utf-8'))
    note='达到迭代上限，未判定收敛。' if not all(c['converged'] for c in report['channels']) else '满足停止条件。'
    self.detail.set('上一张用时%.1f分钟；%s 结果：%s'%(report['seconds']/60,note,self.job/'reconstruction.png'))
  except (OSError,ValueError,KeyError):pass
  self.root.after(1000,self.poll)
 def open_captures(self):os.startfile(str(ROOT/'captures'))
 def open_mvs(self):
  path=Path('F:/MVS/MVS/Applications/Win64/MVS.exe')
  if path.exists():os.startfile(str(path))
  else:messagebox.showinfo('打开MVS','请从桌面打开MVS，并把RAW保存目录设为上方路径。')

if __name__=='__main__':
 try:
  root=tk.Tk();root.option_add('*Font',('Microsoft YaHei UI',10));Window(root);root.mainloop()
 except Exception:
  import traceback
  (ROOT/'auto_gui_errors.log').write_text(traceback.format_exc(),encoding='utf-8')
  try:messagebox.showerror('自动界面启动失败','请查看F盘程序目录的auto_gui_errors.log。')
  except Exception:pass
  raise

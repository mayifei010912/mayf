"""Local VM transport. Reuse existing VM setup credentials without copying them here."""
import ast, pathlib, subprocess, sys
source=pathlib.Path('C:/Users/马逸飞/Documents/Codex/2026-09-20/4-https-blog-csdn-net-qq/work/render_word_vm.py')
values={}
for node in ast.parse(source.read_text(encoding='utf-8')).body:
    if isinstance(node,ast.Assign):
        for target in node.targets:
            if isinstance(target,ast.Name) and target.id in ('runner','vm','base'):
                if isinstance(node.value,ast.List):
                    values[target.id]=[values[x.id] if isinstance(x,ast.Name) else ast.literal_eval(x) for x in node.value.elts]
                else: values[target.id]=ast.literal_eval(node.value)
action=sys.argv[1]
args=sys.argv[2:]
if action=='runProgramInGuestWithSetupPassword':
    action='runProgramInGuest';args.append(values['base'][-1])
if action not in ('CopyFileFromHostToGuest','CopyFileFromGuestToHost','runProgramInGuest'):
    raise SystemExit('Unsupported VM operation')
p=subprocess.run(values['base']+[action,values['vm']]+args,capture_output=True)
output=(p.stdout+p.stderr).decode(errors='replace').replace(values['base'][-1],'<redacted>')
print(output,end='')
raise SystemExit(p.returncode)

"""Copy only required board source/support files to a new, isolated F: project."""
import pathlib,shutil,xml.etree.ElementTree as ET,json,hashlib
R=pathlib.Path(__file__).resolve().parents[1]
V=pathlib.Path('F:/fpga/PenumbraSight_team_20261028/01_vivado/fpga')
S=R/'board_support';S.mkdir(exist_ok=True)
tree=ET.parse(V/'project/board_vendor_gmii.xpr')
hdl=[];constraints=[];audit=[]
def cp(src):
    rel=src.relative_to(V);dst=S/rel;dst.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(src,dst);audit.append(dict(source=str(src),copy=str(dst),sha256=hashlib.sha256(src.read_bytes()).hexdigest()))
    return dst
for fs in tree.findall('.//FileSet'):
    if fs.attrib.get('Name') not in ('sources_1','constrs_1'):continue
    for item in fs.findall('File'):
        src=pathlib.Path(item.attrib['Path'].replace('$PPRDIR',str(V/'project'))).resolve()
        if fs.attrib['Name']=='sources_1':
            if 'source_full' in src.parts or src.suffix.lower() not in ('.v','.sv','.vhd'):continue
            # The new copies of the generic arithmetic have explicit timescales.
            if src.name in ('div_seq.v','isqrt_seq.v'):continue
            hdl.append(cp(src).as_posix())
        elif src.suffix.lower()=='.xdc':
            attrs={a.attrib['Name']:a.attrib['Val'] for a in item.findall('.//Attr')}
            used={a.attrib['Val'] for a in item.findall('.//Attr') if a.attrib['Name']=='UsedIn'}
            constraints.append((cp(src).as_posix(),str('synthesis' in used).lower(),str('implementation' in used).lower(),attrs.get('ProcessingOrder','NORMAL')))
folders=['PenumbraSight_hdmi_fix_20261016','PenumbraSight_reset_sync_20261016','PenumbraSight_rgmii_fix_20261016',
 'PenumbraSight_board_sync_20261017','PenumbraSight_interface_closure_20261017','PenumbraSight_mdio_timing_20261018',
 'PenumbraSight_video_bringup_20261018','PenumbraSight_hpd_fix_20261018']
for name in folders:
    dest=S/name;dest.mkdir(exist_ok=True)
    # The later team package missed one CDC helper. Fill missing files from its
    # canonical original folder, without changing the team package itself.
    for srcdir in (pathlib.Path('F:/fpga')/name,V/name):
        if not srcdir.exists():continue
        for src in srcdir.iterdir():
            if src.is_file() and src.suffix.lower() in ('.tcl','.xdc'):
                text=src.read_text(encoding='utf-8-sig')
                text=text.replace(V.as_posix(),S.as_posix()).replace('F:/fpga/',S.as_posix()+'/')
                (dest/src.name).write_text(text,encoding='utf-8')
bd=R/'board_source/system.bd';bd.parent.mkdir(exist_ok=True)
shutil.copy2(V/'project/source_full/system/system.bd',bd)
repos=[opt.attrib['Val'].replace('$PPRDIR',str(V/'project')) for opt in tree.findall('.//Configuration/Option') if opt.attrib.get('Name')=='IPRepoPath']
def tlist(x):return '{'+' '.join('{'+str(i).replace('\\','/')+'}' for i in x)+'}'
with (R/'scripts/isolated_board_sources.tcl').open('w',encoding='utf-8') as f:
    f.write('set board_hdl '+tlist(hdl)+'\nset board_repos '+tlist(repos)+'\n')
    f.write('set board_constraints {'+' '.join('{'+tlist(v)[1:-1]+'}' for v in constraints)+'}\n')
(R/'reports/board_source_copy_manifest.json').write_text(json.dumps(audit,indent=2),encoding='utf-8')
print('Isolated board HDL',len(hdl),'constraint files',len(constraints),'BD copied; original project unchanged')

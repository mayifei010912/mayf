import pathlib,re
r=pathlib.Path(__file__).resolve().parents[1]
s=(r/'rtl/hybrid_fista_accel.v').read_text()
header=s.split(')(\n',1)[1].split('\n);',1)[0]
header=header.replace('ASSOCIATED_RESET aresetn"','ASSOCIATED_RESET aresetn, FREQ_HZ 50023974"')
header=header.replace('output reg','output wire')
bare=re.sub(r'\(\*.*?\*\)','',header,flags=re.S)
ports=[]
for item in bare.split(','):
    name=re.search(r'(\w+)\s*$',item).group(1);ports.append(name)
wrapper='''// Board-only interface metadata. Vivado clock wizard actual output is
// 50,023,974 Hz for this preserved PS clock. Core arithmetic has no fixed Hz.
`timescale 1ns/1ps
`default_nettype none
module hybrid_fista_board_bd #(parameter integer H=29,W=36)(
'''+header+'\n);\n hybrid_fista_accel #(.H(H),.W(W)) core(\n'+',\n'.join(' .'+p+'('+p+')' for p in ports)+'\n );\nendmodule\n`default_nettype wire\n'
(r/'rtl/hybrid_fista_board_bd.v').write_text(wrapper)
div2=wrapper.replace('module hybrid_fista_board_bd','module hybrid_fista_board_div2_bd').replace('50023974','49999500').replace('50,023,974 Hz','49,999,500 Hz').replace('Vivado clock wizard actual output is','The existing PS clock divided by two is')
(r/'rtl/hybrid_fista_board_div2_bd.v').write_text(div2)
print('Board metadata wrapper generated:',len(ports),'ports')

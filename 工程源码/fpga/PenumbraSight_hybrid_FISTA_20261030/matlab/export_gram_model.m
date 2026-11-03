function export_gram_model()
root=fileparts(fileparts(mfilename('fullpath')));
source='F:\fpga\PenumbraSight_MATLAB_RAW_20261030';addpath(source);setup_project();
e=jsondecode(fileread('F:\fpga\PenumbraSight_fixed_A_RTL_20261030\reports\export_manifest.json'));
assert(strcmp(sha256_file(e.sourceMatrix),e.sourceSHA256));
a=load(e.sourceMatrix,'A');A=a.A;
t=load(e.testSourceResult,'measurement','cfg','report');assert(all(t.report.channelScale==1));
B=A-[A(2:end,:);zeros(1,size(A,2))];
y=reshape(t.measurement,[],3);dy=y-[y(2:end,:);zeros(1,3)];
G=B'*B;bias=B'*dy;
% Same left-inverse order as original tik=0 initialization, no final-image seed.
X0=(G\B')*dy;
assert(max(abs(G(:)))*2^32<2^63-1 && max(abs(bias(:)))*2^32<2^63-1);
assert(max(abs(X0(:)))*2^20<2^31-1);
Gq=int64(round(G*2^32));biasq=int64(round(bias*2^32));xq=int32(round(X0*2^20));
write_bin(fullfile(root,'data','G_q32_rowmajor.bin'),Gq.','int64');
write_bin(fullfile(root,'data','bias_q32_rgb.bin'),biasq,'int64');
write_bin(fullfile(root,'data','initial_x_q20_rgb.bin'),xq,'int32');
L=max(eig(G));stepQ48=floor((1/(1.05*L))*2^48);step=stepQ48/2^48;
thetaQ32=round(t.report.tvReg(1)*step*2^32);
assert(thetaQ32>=256 && thetaQ32<2^32 && stepQ48>0);
meta.sourceA=e.sourceMatrix;meta.sourceSHA256=e.sourceSHA256;meta.sourceResult=e.testSourceResult;
meta.scope='Exact algebra G=B^T*B and bias=B^T*dy; CPU initialization, no target image';
meta.rows=29;meta.cols=36;meta.pixels=1044;meta.GFractionBits=32;meta.biasFractionBits=32;meta.xFractionBits=20;
meta.L=L;meta.safeStepQ48=stepQ48;meta.safeStep=step;
meta.thetaQ32=thetaQ32;meta.tvLambda=t.report.tvReg;meta.cpuOuterMax=1100;meta.cpuOuterTolerance=2.4e-6;
meta.coefficientMaxAbsError=max(abs(double(Gq(:))/2^32-G(:)));
meta.initialization='Original unregularized normal-equation left-inverse applied to measured dy; not warm-started from final reconstruction';
meta.paperSources=verify_paper_sources(source);
save(fullfile(root,'data','gram_float_reference.mat'),'G','bias','X0','dy','meta','-v7.3');
write_json(fullfile(root,'reports','gram_export.json'),meta);
fprintf('[GRAM EXPORT] %dx%d, %.3f MiB, L=%.9g, thetaQ32=%.0f\n',size(G,1),size(G,2),numel(G)*8/2^20,L,thetaQ32);
end
function write_bin(path,v,type)
assert(~isfile(path),'Refuse overwrite');f=fopen(path,'wb','ieee-le');assert(f>=0);cleanup=onCleanup(@()fclose(f));fwrite(f,v,type);
end

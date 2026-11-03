function [rgb, layout]=read_mvs_raw(file, c)
% 无压缩8bit，或12bit低位有效、每像素占16bit的小端RAW。不支持Packed12。
W=c.width; H=c.height; block=c.blockSizeRaw;
assert(all(isfinite([W H block c.headerBytes c.rowPaddingBytes])) && ...
 all(mod([W H block c.headerBytes c.rowPaddingBytes],1)==0) && W>0 && H>0 && block>=1);
assert(c.headerBytes>=0 && c.rowPaddingBytes>=0);
fmt=upper(regexprep(char(c.pixelFormat),'[^A-Za-z0-9]',''));
bayer8=ismember(fmt,{'BAYERRG8','BAYERGR8','BAYERGB8','BAYERBG8'});
bayer12=ismember(fmt,{'BAYERRG12','BAYERGR12','BAYERGB12','BAYERBG12'});
bayer=bayer8 || bayer12;
packed=ismember(fmt,{'RGB8','RGB8PACKED','BGR8','BGR8PACKED'});
mono=ismember(fmt,{'MONO8','MONO12'});
wide=bayer12 || strcmp(fmt,'MONO12'); bitDepth=8+4*wide; maxDN=2^bitDepth-1;
assert(bayer || packed || mono,'Project:PixelFormat', ...
 '不支持%s；仅接受8bit或明确的unpacked 12bit，Packed格式需专用解包。',c.pixelFormat);
bytesPerPixel=1+2*packed+wide; stride=W*bytesPerPixel+c.rowPaddingBytes;
info=dir(file); assert(~isempty(info),'Project:RAWFile','文件不存在：%s',file);
expected=c.headerBytes+H*stride;
assert(info.bytes==expected,'Project:RAWSize', ...
 'RAW字节数不符：实际%d，按%s/%dx%d应为%d。请核对格式，不要直接改扩展名。', ...
 info.bytes,c.pixelFormat,W,H,expected);
fid=fopen(file,'rb'); assert(fid>=0,'Project:FileOpen','无法打开：%s',file);
cleanup=onCleanup(@()fclose(fid)); fseek(fid,c.headerBytes,'bof');
bytes=fread(fid,[stride H],'*uint8').'; bytes=bytes(:,1:W*bytesPerPixel);
if wide
 pixels=uint16(bytes(:,1:2:end))+bitshift(uint16(bytes(:,2:2:end)),8);
 assert(all(pixels(:)<=maxDN),'Project:RAWBitRange', ...
  '12bit小端低位有效数据出现>4095的值；核对字节序、打包方式及有效位对齐。');
else
 pixels=bytes;
end
if bayer
 assert(mod(W,2)==0 && mod(H,2)==0 && mod(block,2)==0 && mod(W,block)==0 && mod(H,block)==0, ...
   'Project:BayerBlock','Bayer图像宽高及blockSizeRaw必须满足偶数整除。');
 switch regexprep(fmt,'(8|12)$','')
  case 'BAYERRG', phases=[1 1;1 2;2 1;2 2]; % R,G,G,B
  case 'BAYERGR', phases=[1 2;1 1;2 2;2 1];
  case 'BAYERGB', phases=[2 1;1 1;2 2;1 2];
  case 'BAYERBG', phases=[2 2;1 2;2 1;1 1];
 end
 sample=@(k)double(pixels(phases(k,1):2:end,phases(k,2):2:end));
 rgb=cat(3,sample(1),(sample(2)+sample(3))/2,sample(4));
 rgb=block_average(rgb,block/2);
elseif packed
 rgb=double(permute(reshape(bytes.',3,W,H),[3 2 1]));
 if startsWith(fmt,'BGR'), rgb=rgb(:,:,[3 2 1]); end
 rgb=block_average(rgb,block);
else
 rgb=block_average(repmat(double(pixels),1,1,3),block);
end
layout.rawWidth=W; layout.rawHeight=H; layout.pixelFormat=c.pixelFormat;
layout.pitchRawPixels=block; layout.firstCenterRawUV=[(block+1)/2 (block+1)/2];
layout.decodedRowsCols=[size(rgb,1) size(rgb,2)]; layout.units=sprintf('%d-bit DN, double; linearity requires camera gamma/LUT disabled',bitDepth);
layout.bitDepth=bitDepth;layout.maxDN=maxDN;layout.bytesPerPixel=bytesPerPixel;
layout.rawMinMaxDN=[double(min(pixels(:))) double(max(pixels(:)))];
layout.rawSaturationFraction=nnz(pixels==maxDN)/numel(pixels);
if wide, layout.byteAlignment='little-endian uint16, low 12 bits valid';
else, layout.byteAlignment='byte aligned'; end
layout.bayerDemosaicUsed=false; layout.perImageNormalizationUsed=false;
end

function out=block_average(a,n)
assert(n>=1 && mod(n,1)==0 && mod(size(a,1),n)==0 && mod(size(a,2),n)==0, ...
 'Project:BlockShape','blockSizeRaw无法整除图像尺寸。');
if n==1, out=a; return; end
h=size(a,1); w=size(a,2); channels=size(a,3);
q=reshape(a,n,h/n,n,w/n,channels);
out=reshape(mean(mean(q,1),3),h/n,w/n,channels);
end

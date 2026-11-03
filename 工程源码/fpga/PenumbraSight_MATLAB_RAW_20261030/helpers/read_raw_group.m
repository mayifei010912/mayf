function [average, info, layout]=read_raw_group(inputPath, rawcfg)
files=resolve_raw_files(inputPath,rawcfg); average=[]; frameMeans=zeros(numel(files),3);
for k=1:numel(files)
 [frame,layout]=read_mvs_raw(files{k},rawcfg);
 if k==1, average=zeros(size(frame)); end
 assert(isequal(size(frame),size(average)),'Project:FrameShape','同组RAW尺寸不一致。');
 average=average+(frame-average)/k;
 frameMeans(k,:)=reshape(mean(mean(frame,1),2),1,3);
 if k==1 || mod(k,8)==0 || k==numel(files), fprintf('RAW %d/%d: %s\n',k,numel(files),files{k}); end
end
info.path=inputPath; info.files=files; info.frames=numel(files);
info.firstFileSHA256=sha256_file(files{1}); info.frameMeanRGBDN=frameMeans;
info.meanRGBDN=reshape(mean(mean(average,1),2),1,3);
info.meanFrameBrightnessStdDN=std(frameMeans,0,1);
info.layout=layout;
end

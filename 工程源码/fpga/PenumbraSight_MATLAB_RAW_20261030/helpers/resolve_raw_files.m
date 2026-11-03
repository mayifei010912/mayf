function files=resolve_raw_files(inputPath, rawcfg)
assert(~isempty(inputPath),'Project:RAWPath','RAW路径为空，请修改experiment_config.m。');
if isfile(inputPath)
 files={char(inputPath)};
elseif isfolder(inputPath)
 d=dir(fullfile(inputPath,rawcfg.filePattern)); d=d(~[d.isdir]);
 [~,order]=sort(lower(string({d.name}))); d=d(order);
 files=arrayfun(@(x)fullfile(x.folder,x.name),d,'UniformOutput',false);
else
 error('Project:RAWPath','RAW文件/文件夹不存在：%s',inputPath);
end
assert(~isempty(files),'Project:NoRAW','未找到RAW文件：%s',inputPath);
if isfinite(rawcfg.maxFrames)
 assert(rawcfg.maxFrames>=1 && mod(rawcfg.maxFrames,1)==0);
 files=files(1:min(numel(files),rawcfg.maxFrames));
end
end

function p = new_run_dir(root, prefix)
base = fullfile(root,'output');
if ~isfolder(base), mkdir(base); end
tag = char(datetime('now','Format','yyyyMMdd_HHmmss_SSS'));
p = fullfile(base,[prefix '_' tag]);
assert(~isfolder(p),'Project:OutputExists','输出目录已存在：%s',p);
mkdir(p);
end

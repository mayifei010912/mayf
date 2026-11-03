function matrixFile = step1_precompute_A(cfg)
% 入口一：仅用实测几何预计算A，不读任何RAW或目标图案。
root=setup_project();
if nargin<1, cfg=experiment_config(); end
sourceReport=verify_paper_sources(root);
[wallparam,occ_corner,simuParams,Mon_xdiscr,Mon_zdiscr,meta]=paper_geometry(cfg);
matrixFile=cfg.paths.matrixFile;
assert(~isfile(matrixFile) || cfg.output.allowMatrixOverwrite,'Project:MatrixExists', ...
 '矩阵文件已存在。更换matrixFile名称，或明确设置allowMatrixOverwrite=true。');
assert(exist('poly2mask','file')~=0,'Project:ImageToolboxNeeded','作者遮挡模型使用poly2mask，需要Image Processing Toolbox。');
switch cfg.transport.backend
 case 'original_gpu'
  assert(exist('gpuArray','class')~=0 && exist('gpuDeviceCount','file')~=0, ...
      'Project:GPUUnavailable','原版需要GPU工具箱；可手动选择cpu_same_formula设备适配。');
  assert(gpuDeviceCount>0,'Project:GPUUnavailable','没有可用GPU；可手动选择cpu_same_formula。');
  wallparam.wall_matr=gpuArray(wallparam.wall_matr);
 case 'cpu_same_formula'
  addpath(fullfile(root,'cpu_transport'),'-begin');
 otherwise
  error('Project:Backend','未知transport.backend。');
end
meta.transportFunction=which('simulate_A'); meta.backend=cfg.transport.backend;
tic;
A=simulate_A(wallparam,occ_corner,simuParams,Mon_xdiscr,Mon_zdiscr,0);
meta.elapsedSeconds=toc;
assert(isequal(size(A),[cfg.wall.gridSize^2 prod(cfg.source.gridRowsCols)]));
assert(all(isfinite(A(:))) && all(A(:)>=0) && any(A(:)>0),'Project:MatrixInvalid','矩阵无效。');
meta.modelKey=model_key(cfg); meta.config=cfg; meta.paperSources=sourceReport;
meta.realImageRecoveryValidated=false; meta.rawInputUsed=false;
meta.transportFileSHA256=sha256_file(meta.transportFunction);
meta.simulateBlockSHA256=sha256_file(which('simulate_block'));
parent=fileparts(matrixFile); if ~isfolder(parent), mkdir(parent); end
save(matrixFile,'A','meta','-v7.3');
write_json([matrixFile '.json'],meta);
fprintf('[PASS MATRIX_BUILD_ONLY] %d x %d, %.2fs\n%s\n',size(A,1),size(A,2),meta.elapsedSeconds,matrixFile);
fprintf('仅通过矩阵生成检查；尚未读取真实图像，不代表复原成功。\n');
end

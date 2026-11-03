function stats=validate_saved_A(cfg)
% 从磁盘读回已生成的A，检查数值/配置签名；不证明实际光学模型准确。
root=setup_project();if nargin<1, cfg=experiment_config(); end
data=load(cfg.paths.matrixFile,'A','meta');A=data.A;
stats.size=size(A);stats.elementCount=numel(A);stats.dataClass=class(A);
stats.finite=all(isfinite(A(:)));stats.nonnegative=all(A(:)>=0);
stats.minimum=min(A(:));stats.maximum=max(A(:));
stats.zeroColumns=nnz(~any(A>0,1));
stats.minimumPositiveSamplesPerColumn=min(sum(A>0,1));
stats.maximumPositiveSamplesPerColumn=max(sum(A>0,1));
stats.modelMatchesCurrentConfig=strcmp(data.meta.modelKey,model_key(cfg));
stats.backend=data.meta.backend;stats.matrixGenerationSeconds=data.meta.elapsedSeconds;
stats.paperSourceCheck=verify_paper_sources(root);
file=dir(cfg.paths.matrixFile);stats.bytesOnDisk=file.bytes;
stats.sha256=sha256_file(cfg.paths.matrixFile);
stats.rawInputUsed=false;stats.realImageRecoveryValidated=false;
assert(isequal(stats.size,[cfg.wall.gridSize^2 prod(cfg.source.gridRowsCols)]) && ...
 stats.finite && stats.nonnegative && stats.maximum>0 && stats.zeroColumns==0 && ...
 stats.modelMatchesCurrentConfig,'Project:SavedMatrixInvalid','磁盘矩阵检查未通过。');
write_json(fullfile(root,'output','A_measured_disk_validation.json'),stats);
fprintf('[PASS SAVED MATRIX CHECK] %dx%d, %d bytes, %s\n',stats.size(1),stats.size(2),stats.bytesOnDisk,stats.sha256);
end

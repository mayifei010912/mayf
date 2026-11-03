function check_camera_mapping()
% Pure computer calibration check; no RAW capture, reconstruction or board access.
app=fileparts(fileparts(mfilename('fullpath')));
source='F:/fpga/PenumbraSight_MATLAB_RAW_20261030';addpath(source);setup_project();addpath(app);
base='F:/fpga/PenumbraSight_hybrid_FISTA_20261030';
meta=jsondecode(fileread(fullfile(base,'reports','gram_export.json')));
frozen=load(meta.sourceResult,'cfg');old=frozen.cfg;
[cfg,info]=apply_job_camera_mapping(old,app);
assert(isequal(cfg.mapping.wallXZCm,[1 44;1.5 9.5;51 34.5;50.5 16]));
assert(isequaln(cfg.scene,old.scene) && isequaln(cfg.wall.rectangleCm,old.wall.rectangleCm));
assert(isequaln(cfg.source,old.source) && isequaln(cfg.singleRaw,old.singleRaw));
[H,fit]=fit_wall_homography(cfg.mapping,cfg.raw);
assert(max(fit.fittedPointErrorCm)<1e-8);
rect=cfg.wall.rectangleCm;N=cfg.wall.gridSize;
[xx,zz]=meshgrid(linspace(rect(1),rect(1)+rect(3),N),linspace(rect(2)+rect(4),rect(2),N));
uv=apply_homography(inv(H),[xx(:) zz(:)]/100);
% Existing Bayer split uses 2x2 cells with raw centers 1.5 ... width-0.5.
assert(all(uv(:,1)>=1.5 & uv(:,1)<=cfg.raw.width-.5 & uv(:,2)>=1.5 & uv(:,2)<=cfg.raw.height-.5));
[legacy,legacyInfo]=apply_job_camera_mapping(old,fullfile(app,'checks','nonexistent_legacy_job'));
assert(isequaln(legacy,old) && strcmp(legacyInfo.source,'legacy_frozen_config'));
assert(strcmp(sha256_file(meta.sourceA),meta.sourceSHA256));
report=struct('status','PASS','camera_mapping',info,'homography_raw_to_wall_m',H, ...
 'corner_fit_error_cm',fit.fittedPointErrorCm,'independently_validated',false, ...
 'wall_rectangle_cm',rect,'wall_sample_grid',N,'raw_uv_bounds',[min(uv);max(uv)], ...
 'A_unchanged',true,'scene_unchanged',true,'legacy_jobs_unchanged',true, ...
 'hardware_access',false,'reconstruction_executed',false);
write_json(fullfile(app,'checks','camera_mapping_report.json'),report);
disp('CAMERA_MAPPING_CHECK_PASS');
end

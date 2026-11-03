function prepare_job(jobdir)
app=fileparts(mfilename('fullpath'));
base='F:/fpga/PenumbraSight_hybrid_FISTA_20261030';
source='F:/fpga/PenumbraSight_MATLAB_RAW_20261030';addpath(source);setup_project();
request=jsondecode(fileread(fullfile(jobdir,'capture.json')));
meta=jsondecode(fileread(fullfile(base,'reports','gram_export.json')));
assert(strcmp(sha256_file(meta.sourceA),meta.sourceSHA256),'Fixed A changed');
frozen=load(meta.sourceResult,'cfg');cfg=frozen.cfg;
% Only new jobs carrying their own mapping snapshot use the new camera corners.
% Existing jobs without it retain the original frozen calibration.
[cfg,cameraMapping]=apply_job_camera_mapping(cfg,jobdir);
assert(all(cfg.singleRaw.channelScale==1));
cfg.raw.measurementPath=request.raw_path;
model=load(meta.sourceA,'A');A=model.A;
[H,mapping]=fit_wall_homography(cfg.mapping,cfg.raw);
[rgb,layout]=read_mvs_raw(request.raw_path,cfg.raw);
[measurement,sampling]=sample_wall_image(rgb,layout,H,cfg.wall);
B=A-[A(2:end,:);zeros(1,size(A,2))];
y=reshape(measurement,[],3);dy=y-[y(2:end,:);zeros(1,3)];bias=B'*dy;
assert(all(isfinite(bias(:))) && max(abs(bias(:)))*2^32<2^63-1,'Bias outside supported range');
f=fopen(fullfile(jobdir,'bias_q32_rgb.bin'),'wb','ieee-le');assert(f>=0);fwrite(f,int64(round(bias*2^32)),'int64');fclose(f);
imwrite(min(1,max(0,rgb/layout.maxDN*cfg.display.previewGain)),fullfile(jobdir,'raw_preview.png'));
imwrite(min(1,max(0,measurement/layout.maxDN*cfg.display.previewGain)),fullfile(jobdir,'wall_preview.png'));
save(fullfile(jobdir,'measurement.mat'),'measurement','cfg','H','mapping','sampling','layout','bias','-v7.3');
report=struct('matrix_sha256',meta.sourceSHA256,'raw_sha256',sha256_file(request.raw_path), ...
 'bias_sha256',sha256_file(fullfile(jobdir,'bias_q32_rgb.bin')),'width',cfg.raw.width,'height',cfg.raw.height, ...
 'pixel_format',cfg.raw.pixelFormat,'screen_size_cm',cfg.scene.screenSizeCm,'source_grid',[29 36], ...
 'preview_gain',cfg.display.previewGain,'no_dark_or_white',true,'target_image_used',false);
report.camera_mapping=cameraMapping;
write_json(fullfile(jobdir,'input_report.json'),report);
disp('MVS_PREPROCESS_COMPLETE');
end

function [cfg,info]=apply_job_camera_mapping(cfg,jobdir)
% Replace camera mapping only; preserve the fixed physical wall grid and model.
path=fullfile(jobdir,'camera_mapping.json');
info=struct('source','legacy_frozen_config','wall_corners_xz_cm',cfg.mapping.wallXZCm, ...
 'independently_validated',false);
if ~isfile(path),return;end
m=jsondecode(fileread(path));
assert(strcmp(m.units,'cm') && isequal(string(m.corner_order(:)),["UL";"LL";"UR";"LR"]), ...
 'Project:CameraMappingOrder','Camera corners must be UL LL UR LR in cm.');
assert(m.raw_width==cfg.raw.width && m.raw_height==cfg.raw.height, ...
 'Project:CameraMappingResolution','Camera mapping resolution differs from RAW.');
corners=m.wall_corners_xz_cm;
assert(isequal(size(corners),[4 2]) && all(isfinite(corners(:))), ...
 'Project:CameraMappingCorners','Four finite camera corner coordinates required.');
polygon=corners([1 3 4 2],:);
assert(polyarea(polygon(:,1),polygon(:,2))>0,'Project:CameraMappingDegenerate','Zero camera field area.');
cfg.mapping.rawUV=[1 1;1 cfg.raw.height;cfg.raw.width 1;cfg.raw.width cfg.raw.height];
cfg.mapping.wallXZCm=corners;cfg.mapping.confirmed=true;
cfg.mapping.checkRawUV=zeros(0,2);cfg.mapping.checkWallXZCm=zeros(0,2);
cfg.wall.cameraCornersXZCm=corners;
info=struct('source','job_camera_mapping.json','version',m.version, ...
 'sha256',sha256_file(path),'corner_order',{{'UL','LL','UR','LR'}}, ...
 'wall_corners_xz_cm',corners,'independently_validated',false);
end

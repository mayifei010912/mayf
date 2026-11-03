function report=check_measured_geometry(cfg)
% 在白板物理坐标中检查采样矩形/小片理论半影；不读取RAW，不拟合图案。
root=setup_project(); if nargin<1, cfg=experiment_config(); end
validate_scene(cfg); s=cfg.scene;
corners=cfg.wall.cameraCornersXZCm; polygon=corners([1 3 4 2],:);
r=cfg.wall.rectangleCm; N=cfg.wall.gridSize;
[xx,zz]=meshgrid(linspace(r(1),r(1)+r(3),N),linspace(r(2),r(2)+r(4),N));
[inside,on]=inpolygon(xx,zz,polygon(:,1),polygon(:,2));
assert(all(inside(:)|on(:)),'Project:RectangleOutsideView','白板矩形有采样点不在用户测量的取景四边形内。');
S=s.screenCenterXZCm; halfS=s.screenSizeCm/2;
O=s.occluderCenterXZCm; halfO=s.occluderSizeCm/2;
sourceMin=S-halfS;sourceMax=S+halfS;occMin=O-halfO;occMax=O+halfO;
d=s.occluderWallFacingDistanceCm;
if strcmp(s.occluderPlane,'midplane'), d=d+s.occluderThicknessCm/2; end
D=s.screenWallDistanceCm;
shadowMin=(D*occMin-d*sourceMax)/(D-d);
shadowMax=(D*occMax-d*sourceMin)/(D-d);
report.cameraCornersOrder='UL LL UR LR';report.cameraCornersXZCm=corners;
report.sourceBoundsXZCm=[sourceMin;sourceMax];report.occluderBoundsXZCm=[occMin;occMax];
report.fullMainOccluderShadowBoundsXZCm=[shadowMin;shadowMax];
report.shadowDerivation='WallXZ=(D*occluderXZ-d*sourceXZ)/(D-d), thin parallel occluder plane';
report.wallRectangleCm=r;report.allGridSamplesInsideCameraQuadrilateral=true;
report.fullMainShadowInsideROI=all(shadowMin>=[r(1) r(2)]) && all(shadowMax<=[r(1)+r(3) r(2)+r(4)]);
assert(report.fullMainShadowInsideROI,'Project:MainShadowClipped','采样矩形未包含小片的完整理论半影包络。');
report.supportIncluded=s.includeSupport;
report.thicknessModel=sprintf('Author zero-thickness plane: %s; recorded physical thickness %.3fcm',s.occluderPlane,s.occluderThicknessCm);
report.rawSizeAndPixelMappingVerified=false;report.independentCalibrationPointProvided=~isempty(cfg.mapping.checkRawUV);
report.measuredGeometryOnly=true;report.realImageRecoveryValidated=false;
write_json(fullfile(root,'output','measured_geometry_check.json'),report);
fig=figure('Visible','off','Color','w','Position',[100 100 900 620]);cleanup=onCleanup(@()close(fig));
plot([polygon(:,1);polygon(1,1)],[polygon(:,2);polygon(1,2)],'k-o','LineWidth',1.5);hold on;
rectangle('Position',r,'EdgeColor',[0 .5 .8],'LineWidth',2);
rectangle('Position',[shadowMin shadowMax-shadowMin],'EdgeColor',[.8 .2 0],'LineStyle','--','LineWidth',2);
labels={'UL','LL','UR','LR'};
for k=1:4, text(corners(k,1)+.5,corners(k,2),sprintf('%s (%.1f, %.1f)',labels{k},corners(k,:))); end
text(r(1)+1,r(2)+1,'Blue: sampling ROI','Color',[0 .4 .7]);
text(shadowMin(1)+.3,shadowMax(2)+.7,'Red: predicted main-occluder shadow envelope','Color',[.7 .1 0]);
xlabel('Wall x (cm)');ylabel('Wall z (cm)');axis equal;grid on;xlim([0 58]);ylim([5 48]);
title({'Measured camera field of view and physical sampling region','Geometry prediction only; not a captured image or reconstruction'});
exportgraphics(fig,fullfile(root,'output','measured_geometry_check.png'),'Resolution',150);
fprintf('Geometry OK: ROI x=[%.1f %.1f], z=[%.1f %.1f] cm\n',r(1),r(1)+r(3),r(2),r(2)+r(4));
fprintf('Predicted main shadow: x=[%.3f %.3f], z=[%.3f %.3f] cm\n',shadowMin(1),shadowMax(1),shadowMin(2),shadowMax(2));
end

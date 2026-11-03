function [wallparam, occ_corner, simuParams, Mon_xdiscr, Mon_zdiscr, meta] = paper_geometry(c)
% 输入白板y=0、屏幕y=D；转换为作者屏幕y=0、白板y=D。x/z不变。
validate_scene(c);
s=c.scene; D=s.screenWallDistanceCm/100; N=c.wall.gridSize;
rect=c.wall.rectangleCm/100; xmin=rect(1); zmin=rect(2); width=rect(3); height=rect(4);
wallparam.wall_point=[xmin+width/2,D,zmin+height/2];
wallparam.wall_vector_1=[width/2,0,0];
wallparam.wall_vector_2=[0,0,height/2];
normal=cross(wallparam.wall_vector_1,wallparam.wall_vector_2);
wallparam.wall_normal=normal/norm(normal); wallparam.walln_points=N;
t=linspace(-1,1,N);
wallparam.wall_matr=[xmin+width/2+t*width/2; D*ones(1,N); zmin+height/2+t*height/2];

rows=c.source.gridRowsCols(1); cols=c.source.gridRowsCols(2);
sw=s.screenSizeCm(1)/100; sh=s.screenSizeCm(2)/100;
cx=s.screenCenterXZCm(1)/100; cz=s.screenCenterXZCm(2)/100;
cellw=sw/cols; cellh=sh/rows;
% 作者simulate_A按每个小块的右上边界向左/下离散。使实际矩形恰好覆盖实测范围。
Mon_xdiscr=cx-sw/2+(1:cols)*cellw;
Mon_zdiscr=cz+sh/2-(0:rows-1)*cellh;
distance=s.occluderWallFacingDistanceCm;
if strcmp(s.occluderPlane,'midplane'), distance=distance+s.occluderThicknessCm/2; end
oy=D-distance/100; ox=s.occluderCenterXZCm(1)/100; oz=s.occluderCenterXZCm(2)/100;
ow=s.occluderSizeCm(1)/100; oh=s.occluderSizeCm(2)/100;
occ_corner=[ox-ow/2,oy,oz-oh/2;ox+ow/2,oy,oz-oh/2; ...
            ox+ow/2,oy,oz+oh/2;ox-ow/2,oy,oz+oh/2];
if s.includeSupport
 rx=s.supportCenterXCm/100; rw=s.supportDiameterCm/100;
 rz=s.supportBottomTopZCm/100;
 occ_corner(:,:,2)=[rx-rw/2,oy,rz(1);rx+rw/2,oy,rz(1);rx+rw/2,oy,rz(2);rx-rw/2,oy,rz(2)];
end
simuParams.NumBlocks=[rows cols]; simuParams.Ndiscr_mon=c.transport.subsamplesPerAxis;
simuParams.numPixels=N; simuParams.D=D; simuParams.FOV_cord=[xmin zmin;xmin+width zmin+height];
simuParams.Occluder=[ox-ow/2 oy oz-oh/2;ox+ow/2 oy oz+oh/2];
simuParams.viewAngleCorrection=c.transport.viewAngleCorrection;
simuParams.IlluminationBlock_Size=[cellw cellh]; simuParams.Mon_Offset=[cx-sw/2 cz-sh/2];
meta.sourceRowsCols=[rows cols]; meta.wallGridSize=N;
meta.wallRectangleM=rect; meta.authorScreenPlaneY=0; meta.authorWallPlaneY=D;
meta.occluderPlaneY=oy; meta.occluderApproximation='Author zero-thickness polygon; support is a coplanar rectangle, not a cylinder';
meta.recordedOccluderThicknessCm=s.occluderThicknessCm;
meta.sourceColumnOrder='Author: world x decreasing by output column; world z decreasing by row; MATLAB column-major';
meta.wallRowOrder='Author image(:): rows z decreasing, columns x increasing; MATLAB column-major';
meta.sourceGridConvention='Measured rectangle divided into contiguous cells; Mon_xdiscr/Mon_zdiscr are upper-right boundaries used by unchanged simulate_A';
end

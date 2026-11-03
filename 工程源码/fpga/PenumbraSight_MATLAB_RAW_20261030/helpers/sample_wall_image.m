function [image, info]=sample_wall_image(rgb, layout, HrawToWall, wallcfg)
rect=wallcfg.rectangleCm/100; N=wallcfg.gridSize;
x=linspace(rect(1),rect(1)+rect(3),N);
z=linspace(rect(2)+rect(4),rect(2),N); % 必须与原simulate_A的flipud保持一致
[xx,zz]=meshgrid(x,z); world=[xx(:) zz(:)];
uv=apply_homography(inv(HrawToWall),world);
u=(uv(:,1)-layout.firstCenterRawUV(1))/layout.pitchRawPixels+1;
v=(uv(:,2)-layout.firstCenterRawUV(2))/layout.pitchRawPixels+1;
assert(all(u>=1 & u<=size(rgb,2) & v>=1 & v<=size(rgb,1)), ...
 'Project:ROIOutsideFrame','白板采样矩形有部分落在RAW有效区域外；不能用黑色填充或随意拉伸。');
image=zeros(N,N,3);
for c=1:3, image(:,:,c)=reshape(interp2(rgb(:,:,c),u,v,'linear'),N,N); end
assert(all(isfinite(image(:))),'Project:SamplingNonfinite','白板图像采样失败。');
info.rawUVMinMax=[min(uv,[],1);max(uv,[],1)]; info.wallSize=[N N];
info.order='Image rows z decreasing, columns x increasing; flatten with MATLAB image(:)';
info.targetWorldXZCm=100*world;
end

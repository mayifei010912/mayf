function [H, info]=fit_wall_homography(mapping, rawcfg)
assert(mapping.confirmed,'Project:MappingNeeded', ...
 '请填写mapping.rawUV/wallXZCm，并确认它们对应本次RAW像素坐标。');
uv=mapping.rawUV; world=mapping.wallXZCm/100;
assert(isequal(size(uv),size(world)) && size(uv,2)==2 && size(uv,1)>=4 && ...
 all(isfinite(uv(:))) && all(isfinite(world(:))),'Project:MappingPoints','至少需要4对有效、不共线的标记坐标。');
assert(all(uv(:,1)>=1 & uv(:,1)<=rawcfg.width & uv(:,2)>=1 & uv(:,2)<=rawcfg.height), ...
 'Project:RawCoordinates','rawUV应为原始RAW内从1开始的[列 行]坐标，不是缩放预览坐标。');
[a,T]=normalise(uv); [b,U]=normalise(world); M=zeros(2*size(uv,1),9);
for k=1:size(uv,1)
 u=a(k,1);v=a(k,2);x=b(k,1);z=b(k,2);
 M(2*k-1,:)=[-u -v -1 0 0 0 u*x v*x x];
 M(2*k,:)=[0 0 0 -u -v -1 u*z v*z z];
end
assert(rank(M)>=8,'Project:MappingDegenerate','标记点共线或布局退化。');
[~,~,V]=svd(M); H=U\reshape(V(:,end),3,3).'*T; H=H/H(3,3);
delta=apply_homography(H,uv)-world;
info.fittedPointErrorCm=100*sqrt(sum(delta.^2,2));
info.independentPointsProvided=~isempty(mapping.checkRawUV);
info.independentlyValidated=false;
if info.independentPointsProvided
 assert(isequal(size(mapping.checkRawUV),size(mapping.checkWallXZCm)));
 delta=apply_homography(H,mapping.checkRawUV)-mapping.checkWallXZCm/100;
 info.independentErrorCm=100*sqrt(sum(delta.^2,2));
 info.independentlyValidated=all(info.independentErrorCm<=mapping.maxIndependentErrorCm);
 assert(info.independentlyValidated,'Project:IndependentMappingFail', ...
   '独立点映射误差超过%.3fcm，先核对本次坐标对应关系。',mapping.maxIndependentErrorCm);
else
 info.independentErrorCm=[];
 warning('Project:MappingUnvalidated','映射没有独立点检查；4点拟合误差小不等于物理坐标准确。');
end
end

function [q,T]=normalise(p)
center=mean(p,1); radius=mean(sqrt(sum((p-center).^2,2)));
assert(radius>eps,'Project:MappingDegenerate','重复标记点。');
scale=sqrt(2)/radius; T=[scale 0 -scale*center(1);0 scale -scale*center(2);0 0 1];
q=apply_homography(T,p);
end

function out=apply_homography(H, xy)
assert(size(xy,2)==2 && all(isfinite(xy(:))));
q=[xy ones(size(xy,1),1)]*H.';
assert(all(abs(q(:,3))>1e-12),'Project:HomographyPole','坐标映射接近无穷远。');
out=q(:,1:2)./q(:,3);
end

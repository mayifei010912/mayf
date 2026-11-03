function compare_hybrid_reference()
root=fileparts(fileparts(mfilename('fullpath')));
m=jsondecode(fileread(fullfile(root,'reports','gram_export.json')));
s=load(m.sourceResult,'X_native'); b=load(fullfile(root,'data','gram_float_reference.mat'),'G','bias','dy');
f=fopen(fullfile(root,'reports','hybrid_reference_RGB_native.bin'),'r','ieee-le');
X=reshape(fread(f,m.pixels*3,'double'),m.rows,m.cols,3);fclose(f);
reference=s.X_native;
tv=@(x)sum(sqrt([diff(x,1,1).^2;zeros(1,size(x,2))]+[diff(x,1,2).^2,zeros(size(x,1),1)]),'all');
objectives=zeros(1,2);
for c=1:3
 x=reference(:,:,c);v=x(:);objectives(1)=objectives(1)+.5*v'*b.G*v-b.bias(:,c)'*v+.5*sum(b.dy(:,c).^2)+m.tvLambda(c)*tv(x);
 x=X(:,:,c);v=x(:);objectives(2)=objectives(2)+.5*v'*b.G*v-b.bias(:,c)'*v+.5*sum(b.dy(:,c).^2)+m.tvLambda(c)*tv(x);
end
scale=max(reference,[],'all');before=max(0,min(1,reference/scale));after=max(0,min(1,X/scale));
report=struct('scope','CPU integer model with ARM FISTA; not physical FPGA frame', ...
 'native_size',[m.rows,m.cols],'signed_relative_L2',norm(X(:)-reference(:))/norm(reference(:)), ...
 'display_RMSE_common_RGB_scale',sqrt(mean((before(:)-after(:)).^2)), ...
 'original_objective',objectives(1),'hybrid_model_objective',objectives(2),'objective_ratio',objectives(2)/objectives(1), ...
 'note','Fixed-point adaptations and finite iteration limit can change solution; no target image quality claim');
f=fopen(fullfile(root,'reports','hybrid_reference_comparison.json'),'w');fprintf(f,'%s',jsonencode(report,PrettyPrint=true));fclose(f);
imwrite(before,fullfile(root,'reports','original_native.png'));imwrite(after,fullfile(root,'reports','hybrid_CPU_native.png'));
f=figure('Visible','off','Color','w','Position',[0 0 1100 430]);
tiledlayout(1,2,'Padding','compact');nexttile;imshow(imresize(before,[232,480],'nearest'));title('Original measured-A MATLAB reference');
nexttile;imshow(imresize(after,[232,480],'nearest'));title('New hybrid INTEGER model - CPU only');
sgtitle(sprintf('Same real RAW / same A. Objective ratio %.5f; display RMSE %.4f. Not FPGA frame.',report.objective_ratio,report.display_RMSE_common_RGB_scale));
exportgraphics(f,fullfile(root,'reports','hybrid_CPU_comparison.png'),'Resolution',130);close(f);
save(fullfile(root,'reports','hybrid_reference_comparison.mat'),'X','reference','report');
disp(report);
end

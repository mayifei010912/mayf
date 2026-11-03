function render_physical_rgb()
% Physical board output, with a single shared RGB display scale.
root=fileparts(fileparts(mfilename('fullpath')));
meta=jsondecode(fileread(fullfile(root,'reports','physical_rgb_full_comparison.json')));
assert(meta.complete_RGB && meta.all_array_equal && meta.max_abs_difference==0);
X_board=zeros(29,36,3);X_cpu=X_board;
letters='rgb';
for c=1:3
 f=fopen(fullfile(root,'reports',['physical_' letters(c) '_native.bin']),'r','ieee-le');assert(f>=0);
 v=fread(f,1044,'double=>double');fclose(f);assert(numel(v)==1044);X_board(:,:,c)=reshape(v,36,29)';
 f=fopen(fullfile(root,'reports',['cpu_' letters(c) '_native.bin']),'r','ieee-le');assert(f>=0);
 v=fread(f,1044,'double=>double');fclose(f);assert(numel(v)==1044);X_cpu(:,:,c)=reshape(v,36,29)';
end
assert(isequal(X_board,X_cpu));
source=jsondecode(fileread(fullfile(root,'reports','gram_export.json')));
original=load(source.sourceResult,'X_native');X_matlab=original.X_native;
scale=max([X_board(:);X_cpu(:);X_matlab(:);eps]);
board_display=max(0,min(1,X_board/scale));cpu_display=max(0,min(1,X_cpu/scale));
matlab_display=max(0,min(1,X_matlab/scale));
imwrite(board_display,fullfile(root,'reports','physical_rgb_native.png'));
imwrite(imresize(board_display,[232 480],'nearest'),fullfile(root,'reports','physical_rgb_display_physical_aspect.png'));
fig=figure('Visible','off','Color','w','Position',[0 0 1400 440]);
t=tiledlayout(fig,1,3,'TileSpacing','compact');
nexttile;imshow(imresize(board_display,[232 480],'nearest'));title('Physical ARM + FPGA: RGB');
nexttile;imshow(imresize(cpu_display,[232 480],'nearest'));title('CPU integer reference: RGB');
nexttile;imagesc(imresize(max(abs(X_board-X_cpu),[],3),[232 480],'nearest'));axis image;axis off;colorbar;caxis([0 1e-12]);title('Absolute difference: all zero');
title(t,{'Saved real RAW / fixed measured A: physical ARM + FPGA vs CPU integer reference'; ...
 '3132 samples exact | 1100 iterations/channel | outer tolerance not reached'},'FontSize',12);
exportgraphics(fig,fullfile(root,'reports','physical_rgb_full_comparison.png'),'Resolution',150);close(fig);
fig=figure('Visible','off','Color','w','Position',[0 0 1100 430]);
t=tiledlayout(fig,1,2,'TileSpacing','compact');
nexttile;imshow(imresize(matlab_display,[232 480],'nearest'));title('Original measured-A MATLAB double result');
nexttile;imshow(imresize(board_display,[232 480],'nearest'));title('Physical ARM + FPGA integer kernel result');
title(t,'Same real RAW / same measured A / common RGB scale. Not a live-camera frame or target-quality test.');
exportgraphics(fig,fullfile(root,'reports','physical_rgb_vs_matlab.png'),'Resolution',150);close(fig);
save(fullfile(root,'reports','physical_rgb_result.mat'),'X_board','X_cpu','X_matlab','meta','scale');
disp('PHYSICAL_RGB_RENDERED_AND_NUMERICALLY_VERIFIED');
end

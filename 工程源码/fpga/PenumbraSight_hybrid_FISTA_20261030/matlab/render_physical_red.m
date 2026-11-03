% Numerical validation of a physical FPGA result; not a target-quality claim.
root=fileparts(fileparts(mfilename('fullpath')));
meta=jsondecode(fileread(fullfile(root,'reports','physical_red_full_comparison.json')));
f=fopen(fullfile(root,'reports','physical_red_native.bin'),'rb');assert(f>=0);a=reshape(fread(f,1044,'double=>double'),36,29)';fclose(f);
f=fopen(fullfile(root,'reports','cpu_red_native.bin'),'rb');assert(f>=0);b=reshape(fread(f,1044,'double=>double'),36,29)';fclose(f);
scale=max([a(:);b(:);eps]);
fig=figure('Visible','off','Color','w','Position',[100 100 1300 440]);
t=tiledlayout(fig,1,3,'TileSpacing','compact');
nexttile;image(cat(3,max(a,0)/scale,zeros(size(a)),zeros(size(a))));axis image;title('Physical ARM + FPGA: red');xlabel('Source column');ylabel('Source row');
nexttile;image(cat(3,max(b,0)/scale,zeros(size(b)),zeros(size(b))));axis image;title('CPU integer reference: red');xlabel('Source column');ylabel('Source row');
nexttile;imagesc(abs(a-b));axis image;colorbar;title('Absolute numerical difference');caxis([0 max(max(abs(a-b),[],'all'),1e-12)]);
title(t,sprintf('Real RAW | 29 x 36 | %d iterations | tolerance reached: %d | max difference %.6g',meta.iterations,meta.converged,meta.max_abs_difference));
exportgraphics(fig,fullfile(root,'reports','physical_red_full_comparison.png'),'Resolution',150);
close(fig);

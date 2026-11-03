function render_performance()
root=fileparts(fileparts(mfilename('fullpath')));
s=jsondecode(fileread(fullfile(root,'reports','performance_comparison.json')));
assert(s.all_3132_samples_exact);
a=s.short_baseline_categories;b=s.short_fast_categories;
parts=@(x)[x.Gx_vector_load+x.Gx_readback_and_control+x.TV_vector_load+x.TV_readback_and_control, ...
 x.Gx_wait+x.TV_wait,x.ARM_math_and_scheduling];
fig=figure('Visible','off','Color','w','Position',[0 0 1250 470]);
t=tiledlayout(fig,1,2,'TileSpacing','compact');
nexttile;barh([parts(a);parts(b)],'stacked');yticks([1 2]);yticklabels({'Validated baseline','C bulk transport'});
xlabel('Seconds');title('20-iteration red-channel profile');
legend({'Transport + conversion','Gx / TV hardware wait','ARM math + scheduling'},'Location','southoutside');grid on;
nexttile;old=[s.channels.baseline_seconds]/60;new=[s.channels.seconds]/60;
bar([old(:) new(:)]);xticks(1:3);xticklabels({'R','G','B'});ylabel('Minutes');
title('Complete 1100-iteration physical runs');legend({'Baseline','C bulk transport'},'Location','southoutside');grid on;
title(t,{sprintf('Physical ARM + FPGA: %.2fx full-RGB speedup; all 3132 outputs unchanged',s.full_RGB_speedup), ...
 sprintf('RGB: %.2f to %.2f minutes | Same algorithm, matrix, RTL and bit | Not realtime',s.baseline_full_RGB_seconds/60,s.fast_full_RGB_seconds/60)},'FontSize',12);
exportgraphics(fig,fullfile(root,'reports','performance_comparison.png'),'Resolution',150);close(fig);
disp('PERFORMANCE_FIGURE_RENDERED');
end

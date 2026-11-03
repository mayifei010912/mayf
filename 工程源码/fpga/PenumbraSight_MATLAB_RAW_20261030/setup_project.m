function root = setup_project()
root = fileparts(mfilename('fullpath'));
addpath(root, '-begin');
addpath(fullfile(root,'helpers'), '-begin');
addpath(fullfile(root,'paper_original','Functions'), '-begin');
expected = fullfile(root,'paper_original','Functions','reconstruct_tv_it_cbg.m');
assert(strcmpi(which('reconstruct_tv_it_cbg'),expected), ...
    'Project:WrongSolver','未选中本工程保留的论文求解器，请检查MATLAB路径。');
end

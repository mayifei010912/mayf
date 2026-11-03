function cfg = experiment_config()
% 所有需要手动修改的输入集中在本文件。单位：几何输入用厘米。
root = fileparts(mfilename('fullpath'));
cfg.paths.root = root;
cfg.paths.matrixFile = fullfile(root, 'output', 'A_measured.mat');

%% ===== 1. 在这里修改输入RAW：可填单个文件，也可填包含多帧RAW的文件夹 =====
cfg.raw.measurementPath = "C:\Users\马逸飞\Desktop\抓拍图像\Image_20261030164050828_w5472_h3648_pBayerGB12.raw"; % <-- 彩条或BU的RAW
cfg.raw.darkBeforePath  = fullfile(root, 'data', 'dark_before'); % <-- 配对黑屏RAW
cfg.raw.darkAfterPath   = ''; % 可选：fullfile(root,'data','dark_after')
cfg.raw.whitePath       = fullfile(root, 'data', 'white');       % <-- 同范围白场RAW
cfg.raw.filePattern = '*.raw';
cfg.raw.maxFrames = Inf; % 默认读取文件夹内全部匹配文件

%% ===== 2. 必须与MVS保存时一致；下面是此前相机参数，不代表本次已确认 =====
cfg.raw.width = 5472;
cfg.raw.height = 3648;
cfg.raw.pixelFormat = 'BayerGB12'; % 本次文件：unpacked12，每像素uint16小端、低12位有效
cfg.raw.headerBytes = 0; % 无头RAW；文件长度必须严格匹配，不自动猜位深/头长度
cfg.raw.rowPaddingBytes = 0;
cfg.raw.blockSizeRaw = 2; % Bayer至少2且为偶数；2=只拆CFA，不额外空间降采样
cfg.raw.formatConfirmed = true; % 文件名、5472*3648*2字节、有效位范围已核对

%% ===== 3. 2026-10-30用户实测并确认的几何，单位cm =====
cfg.scene.measurementsConfirmed = true;
cfg.scene.screenWallDistanceCm = 56;   % 发光面到白板的垂直距离D
cfg.scene.screenSizeCm = [24 11.6];    % 完整图案矩形，包含图案内部黑缝
cfg.scene.screenCenterXZCm = [30 8];   % 发光区域中心，不是左下角
cfg.scene.parallelPlanesConfirmed = true;
cfg.scene.occluderSizeCm = [6 6];
cfg.scene.occluderCenterXZCm = [30 19];
cfg.scene.occluderWallFacingDistanceCm = 19; % 白板到朝白板表面的距离
cfg.scene.occluderThicknessCm = 0.5; % 仅记录；论文基线仍为零厚度遮挡面
cfg.scene.occluderPlane = 'wall_facing_surface'; % 或midplane；需明确选择，不能混用
cfg.scene.includeSupport = true;
cfg.scene.supportCenterXCm = 30; % 用户确认杆在小片正下方、同深度
cfg.scene.supportDiameterCm = 0.5;
cfg.scene.supportBottomTopZCm = [0 16];

%% ===== 4. 白板采样区域，由实测取景四角内选取，不使用梯形外接矩形 =====
cfg.wall.cameraCornersXZCm = [3 42.5;3 10;51 34;50 16.5]; % 左上、左下、右上、右下
cfg.wall.rectangleCm = [15 16.5 30 17.5]; % x=15~45,z=16.5~34；覆盖小片全部理论半影
cfg.wall.gridSize = 128; % 原simulate_A使用N×N墙面网格；128时A为16384×1044
cfg.source.gridRowsCols = [29 36];
cfg.transport.subsamplesPerAxis = 4; % 论文每个源小块的离散点数/轴
cfg.transport.viewAngleCorrection = 1; % 保留作者的横向1次/纵向18次余弦角度模型
cfg.transport.backend = 'original_gpu'; % 原版GPU；无GPU时手动选cpu_same_formula

%% ===== 5. 像素到白板映射。RAW像素坐标[列u 行v]，从1开始，不是屏幕坐标 =====
% 同一行是一对对应点，至少4个不共线点；真实白板坐标仍用厘米。
% 用户确认这些是相机画面四角。像素坐标随本次真实RAW的宽高更新；不是MVS窗口坐标。
cfg.mapping.rawUV = [1 1;1 cfg.raw.height;cfg.raw.width 1;cfg.raw.width cfg.raw.height];
cfg.mapping.wallXZCm = cfg.wall.cameraCornersXZCm;
cfg.mapping.confirmed = true; % 使用用户确认的完整画面四角；未做独立检查点验证
% 可选：未参与拟合的独立检查点。不填则明确记录“未独立验证”。
cfg.mapping.checkRawUV = zeros(0,2);
cfg.mapping.checkWallXZCm = zeros(0,2);
cfg.mapping.maxIndependentErrorCm = 0.5; % 工程初筛阈值，不是论文给定保证

%% ===== 6. 背景时间权重：有前/后黑屏时，按采集时刻插值 =====
% 用同一时间基准的秒数，也可填POSIX秒数；不用文件修改时间猜测。
cfg.capture.darkBeforeTime = NaN;
cfg.capture.darkAfterTime = NaN;
cfg.capture.measurementTime = NaN;
cfg.capture.whiteTime = NaN;
cfg.capture.fallbackMeasurementAlpha = 0.5; % 无时间信息时使用明确记录的权重
cfg.capture.fallbackWhiteAlpha = 0.5;
cfg.capture.exposureUs = NaN; % 仅记录MVS设置，所有组应相同
cfg.capture.gainDb = NaN;

%% ===== 7. 原论文差分+TV求解参数；不增加谱加权、模板或新约束 =====
cfg.reconstruction.channelScaleMode = 'white_scalar_fit'; % 或manual
cfg.reconstruction.manualChannelScale = [NaN NaN NaN];
cfg.reconstruction.tvReg = [0.05 0.05 0.05]; % 示例初值，尚未对本次RAW标定
cfg.reconstruction.tikReg = [0 0 0]; % 原函数支持；不自动添加ridge
cfg.quality.maxWhiteRelativeError = 0.15; % 白场模型工程筛查，非论文验收标准
cfg.quality.allowUnvalidatedModel = false; % 不通过时默认停在白场检查；true仅作探索

%% ===== 8. 仅显示与输出。输出保留有符号原始重构，不为图片修改数据 =====
cfg.display.previewGain = 6;
cfg.display.flipHorizontal = false; % 只影响预览，不修改A或保存的X_native
cfg.output.allowMatrixOverwrite = false;
cfg.output.showFigures = true;

%% ===== 9. 用户指定：单张RAW直接重构，不用黑场/白场 =====
% MATLAB运行step2_reconstruct_single_raw；不影响原带黑白场的step2_reconstruct_raw。
cfg.singleRaw.channelScale = [1 1 1]; % 未标定：共同单位比例，输出为相对模型系数
cfg.singleRaw.tvReg = [1000 1000 1000]; % 本次12bit直接RAW试算，抑制弱TV产生的杂色；非普适最优值
cfg.singleRaw.noDarkOrWhiteRequested = true;
end

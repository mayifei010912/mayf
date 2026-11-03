# 实测几何预计算 A + MVS RAW + 原论文 MATLAB 求解器

工程位置：`F:\fpga\PenumbraSight_MATLAB_RAW_20261030`。

这是独立离线工程，不调用开发板，不修改之前的 Vivado 工程、FPGA 实时程序或实验结果。所有输入、矩阵和输出均放在本工程或你指定的 F 盘路径。

## 本次单张 RAW 直接运行（2026-10-30）

按用户本次要求：**不使用黑屏、白场 RAW**。已将 `experiment_config.m` 的目标输入指向桌面“抓拍图像”中的 `Image_20261030160344791_w5472_h3648_pBayerGB12.raw`。它是5472×3648、BayerGB12，每像素用小端uint16保存低12位，文件39,923,712字节，读取保留0~4095 DN，不截断成8bit。格式对照了本机海康SDK的 `F:\MVS\MVS\Development\Includes\PixelType.h`；解码增加了超范围拒绝和12位合成样本测试。

当前直接重构命令：

```matlab
cd('F:\fpga\PenumbraSight_MATLAB_RAW_20261030');
step2_reconstruct_single_raw
```

这个新入口使用保存好的 `output\A_measured.mat` 和未改动的 `paper_original\Functions\reconstruct_tv_it_cbg.m`。不读取旧的黑白场路径，也不生成假黑场或假白场。`cfg.singleRaw.channelScale=[1 1 1]` 是未标定的共同单位比例，不代表已知的相机光度校准；输出单位为相对模型系数。单张模式使用独立参数 `cfg.singleRaw.tvReg=[1000 1000 1000]`；0.05、10、100的结果主要为杂色块，1000开始呈现三条色带，作为本次起点，未证明最佳参数。没有根据原图指定彩条位置或黑缝。每次实际参数均写入结果报告，原配对黑白场模式的 `cfg.reconstruction.tvReg` 不受影响。

输出在 `output\single_RAW_direct_...`：`result.mat` 保留有符号 `X_native`，`X_world` 是按世界x向右增加的方向显示的结果。`reconstruction_native.png` 为作者网格方向；`reconstruction_world_physical_aspect.png` 按实测屏幕宽高比显示世界坐标方向；`reconstruction_display_physical_aspect.png` 按显示开关选择方向，默认作者网格方向。仅空间镜像，不交换RGB通道，所有版本共用同一个RGB显示比例。`comparison.png` 左边为相机白板ROI，右边为该显示方向的重构。

`step2_reconstruct_raw` 仍保留原先配对黑场/白场流程，不能与当前单张入口混淆。当前图像尚未做光度校准、背景扣除或独立检查点标定，数值求解结束不等于彩条、黑缝或BU已恢复。

## 先知道两个入口各做什么

| 文件 | 输入 | 输出 |
| --- | --- | --- |
| `experiment_config.m` | 手工填写 RAW 路径、格式、测量几何、像素/白板对应点 | 配置结构 |
| `step0_check_raw.m` | 一帧真实 RAW 及格式参数 | 读图检查、仅供观察的提亮预览 |
| `step1_precompute_A.m` | 实测几何、白板采样区域、源图网格 | `output\A_measured.mat` 内的 A 和计算记录；完全不读取目标图案 |
| `step2_reconstruct_raw.m` | 已保存 A、目标 RAW、黑屏 RAW、白场 RAW | 新建结果目录，保存有符号重构数组及预览图 |

## RAW 究竟在哪里修改

打开 `experiment_config.m`，第 1 节这四行就是输入：

```matlab
cfg.raw.measurementPath = fullfile(root, 'data', 'measurement');
cfg.raw.darkBeforePath  = fullfile(root, 'data', 'dark_before');
cfg.raw.darkAfterPath   = ''; % 可选
cfg.raw.whitePath       = fullfile(root, 'data', 'white');
```

可以把 MVS 保存的多帧 RAW 放入对应文件夹，程序逐帧求平均；也可以直接填写完整文件名。例如：

```matlab
cfg.raw.measurementPath = 'F:\camera_raw\RGB\frame001.raw';
cfg.raw.darkBeforePath  = 'F:\camera_raw\black';
cfg.raw.whitePath       = 'F:\camera_raw\white';
```

之后换成 BU，只改 `measurementPath` 为 BU 的文件/文件夹。**几何、白板采样区和离散网格不变时，不用重新生成 A。** 若换了曝光、增益或屏幕亮度，需要重新配对黑屏、白场数据及比例标定。

## 第一次运行之前必须填写的参数

1. 第 2 节核对 MVS 的实际 Width、Height、PixelFormat。当前 5472×3648、BayerGB8 是旧记录示例，不能代替本次确认。核对后设置 `cfg.raw.formatConfirmed=true`。
2. 第 3 节已填入本次用户实测：D=56cm，屏幕24×11.6cm、中心(30,8)cm；小片6×6cm、中心(30,19)cm、朝白板表面距白板19cm、厚0.5cm。平行关系已经用户确认。支撑杆直径0.5cm、高16cm，在小片正下方同深度，已确认计入。后续移动设备要重新更新几何并生成A。屏幕尺寸指**用于建模的完整图案矩形**，其中应包含图案内部的黑缝；不要只把三个发亮彩条的宽度相加。区域以外若还有亮界面/状态栏，也会产生未建模照明，应关闭。
3. 第 4 节已记录本次相机四角对应的白板坐标：左上(3,42.5)、左下(3,10)、右上(51,34)、右下(50,16.5)cm。四角构成梯形；计算矩形取 `wall.rectangleCm=[15 16.5 30 17.5]`，即x=15~45、z=16.5~34cm，所有采样点位于梯形内，并包含小片理论半影包络。检查图在 `output\measured_geometry_check.png`。它是计算预测，不是实拍或重构图。
4. 第 5 节已按用户确认的“相机画面四角”写入物理坐标，像素角点按 `cfg.raw.width/height` 自动设置。**还需核对本次真实RAW的宽高、格式，确认所指四角是完整RAW而非裁剪预览的四角**，再将 `raw.formatConfirmed` 和 `mapping.confirmed` 设为true。没有沿用之前的旧映射。尚未提供独立检查点，当前坐标映射未独立验证。
5. RAW 必须是同一设置下的测量、全黑、全白。全白要覆盖和目标图案**相同的屏幕矩形**。关闭自动曝光、自动增益、自动白平衡及相机 Gamma/LUT 等非线性处理，固定曝光、增益、光圈、屏幕亮度和显示区域。不要在保存各组之间改变摆位。

### 坐标和矩阵约定

- 用户输入：白板为 y=0，屏幕为 y=D，x 从白板同一左端向右，z 从同一底板向上；屏幕和小片的位置填写**中心**，距离填写垂直距离，不是斜距。
- 程序转换到作者坐标：屏幕 y=0，白板 y=D，小片 y=D-d。x/z 保持不变。
- `occluderWallFacingDistanceCm` 是白板到小片朝白板表面；论文模型使用零厚度遮挡面。厚度会记录，默认使用朝白板表面；选择 `midplane` 才取厚度中面。杆按同深度平面内的矩形近似，不是圆柱模型。
- 作者 A 的列顺序：源图行沿 z 递减、列沿世界 x 递减，MATLAB 列优先展开。墙面采样行沿 z 递减、列沿 x 递增，同样用 `image(:)` 展开。程序保持这组顺序，不擅自翻转矩阵。
- RAW 像素坐标从 **1** 开始；MVS 的缩放显示坐标不能直接用。若某软件提供的是从 0 开始的原始坐标，要明确转换后才填写。Bayer 分块后坐标偏移由接口自动处理。
- 建议另填一个不参与拟合的独立检查点 `checkRawUV/checkWallXZCm`。四点拟合误差接近零并不能证明实测坐标准确。
- 相机镜头到墙面的距离和 F2.4 本身不能确定像素落在白板的哪里；这里用实测对应点完成透视映射，不要求你输入完整内参。它仍采用平面投影近似，明显镜头畸变需另行标定。

## 在 MATLAB 中运行

```matlab
cd('F:\fpga\PenumbraSight_MATLAB_RAW_20261030');
edit experiment_config
```

填好配置后依次运行：

```matlab
step0_check_raw      % 先检查读图、方向、颜色和文件字节数
step1_precompute_A   % 几何改变后才需要重新生成
step2_reconstruct_raw
```

默认使用未改动的作者 GPU 矩阵生成函数，需要 Parallel Computing Toolbox 和可用 NVIDIA GPU；遮挡模型需要 Image Processing Toolbox 的 `poly2mask`。

无 GPU 时，可在配置中手动改为：

```matlab
cfg.transport.backend = 'cpu_same_formula';
```

这个可选路径只把 `simulate_A/simulate_block` 的 GPU 存储、逐元素运算换为 CPU，同一物理公式；**不是逐字相同的原文件**。原文件另存于 `paper_original`，不会覆盖。求解器在两种路径下均使用原文件。

默认墙面 128×128、源图 29×36，A 为 16384×1044。原求解器内部构造稠密差分矩阵，仅该矩阵约占 2GiB double 内存，完整运行还需更多内存和时间。本工程没有为了加速把原求解器换成稀疏或其他版本。首次可以先用较小网格检查流程，但改变网格后要重新计算 A。

已有 A 默认不会被覆盖；几何改变时，先修改 `cfg.paths.matrixFile` 为新名称再运行 step1。

## 与原源码一致到什么范围

`paper_original` 是已有论文源码的完整副本，25 个文件由 SHA-256 清单核对；入口会校验文件是否被改动。重构直接调用其中的 `reconstruct_tv_it_cbg.m`，不更换其差分方式、FISTA/TV、约束和停止规则。该函数**已经在内部差分 A 和测量**，入口不会再差分一次。

接口新增了实际设备必需的 RAW 解码、同设置黑屏相减、白板透视采样和每个颜色通道的单一光强比例。默认比例由白场与 `A*ones(...)` 做一个标量拟合，不是逐像素除白场，也没有加入谱加权、目标模板、按已知彩条裁黑缝或针对 BU 的字形约束。矩阵生成的源小块按实测矩形连续划分，边界约定写在 A 的 meta 中。

原作者读图函数假定另一种 Bayer 排列，不能直接拿来读本相机。新增解码器支持明确的 BayerRG8/GR8/GB8/BG8、对应的未打包12bit格式、RGB8Packed/BGR8Packed、Mono8/Mono12。Bayer 使用 2×2 CFA 中 R、两 G 平均、B，再按配置分块；保留原始 DN，不逐图归一化。Mono只会输出三个相同通道，不能从单色数据恢复真实颜色。Packed12、10bit、带未知文件头的 RAW 会被拒绝，不能改扩展名冒充其他格式。

原始求解超参数依赖数据强度，配置里的 `tvReg=[0.05 0.05 0.05]` 是待验证初值，不代表作者所有数据集使用相同值。`manualChannelScale` 也可以填已标定的三个比例。作者的纵向 18 次余弦发光角度假设保留；它不保证适合每块手机/平板。

**本入口实现的是“已知实测 A 的单次差分 TV 重构”。没有加入遮挡物自定位，也没有把论文 Fig.4(e) 的 49 次移位与合并流程冒称已完整实现。** 旧 FPGA 程序不会被这个离线工程自动更新。

## 检查和结果在哪里

- `output\raw_check_...`：第一帧读取检查和提亮预览。
- `output\A_measured.mat`：A、几何、源文件校验、顺序、后端和模型签名。
- `output\reconstruction_...\inputs_and_checks.mat`：有符号测量、白场、预测白场、映射等。
- 同目录 `checks.json`：白场拟合误差、RAW 名单、背景权重和检查状态。
- 同目录 `result.mat`：有符号 `X_native`、预览方向的 `X_preview` 和报告。
- 同目录 `reconstruction_preview.png`：共同 RGB 显示尺度，仅预览时裁去负值，不能用截图替代数值结果。

白场相对误差默认超过 0.15 会在保存诊断后停止 TV。这是可修改的工程初筛阈值，不是论文验收标准；`allowUnvalidatedModel=true` 可以探索性继续，但报告仍记录未通过，不能解释成恢复有效。通过白场检查也不保证黑缝或 BU 已恢复。

本工程不读手机原图作为重构输入。评价是否恢复黑缝、BU 时可以另外比较原图，但不能将原图混入求解。

## 自检

```matlab
addpath('tests');
selftest_project
```

自检使用 F 盘内的小型合成 RAW，检查字节/颜色顺序、映射、矩阵缓存和原求解器数值接口；不是新的真实实验，也不是证明可以达到论文图像质量。

已在 MATLAB R2024a 运行接口自检：25 个论文原件校验一致，GPU/CPU 小型 A 相对差约 `3.52e-16`，完整合成 RAW 接口相对误差约 `4.36e-11`。旧实时程序的 11 个受保护文件校验未变。后续本次测量数据已正式生成 `output\A_measured.mat`，尺寸16384×1044，使用未修改的论文GPU函数，用时约3.71秒（不含MATLAB启动/存盘）。保存后检查见 `output\A_measured_disk_validation.json`；几何检查见 `output\measured_geometry_check.json`。

当前已新增本次真实RAW的 `single_RAW_direct_...` 结果；旧 `reconstruction_...` 内的结果仍来自**合成自检**，不能当作实拍复原。原配置及8位解码器备份在 `config_history`。需要检查已保存A时可运行 `validate_saved_A`，不必重复计算或覆盖矩阵。

**本轮要理解什么：**先用测量几何生成固定 A，再把相机 RAW 对齐到 A 的墙面采样顺序，最后调用论文求解器。正确读 RAW、成功生成 A、数值求解完成、真实图像复原成功，是四个不同的验证层次。

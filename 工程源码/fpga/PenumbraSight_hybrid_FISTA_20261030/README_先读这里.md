# 实测固定 A 的 ARM + FPGA 协同移植

这个目录是独立的新版本。原 FPGA 实时试验目录、原整板工程、原发布 bit、论文函数和原始 RAW 不在这里修改。

## 最新性能实验：保持结果不变的交互提速

`performance_20261031` 中的 C 批量 MMIO 已通过完整 RGB 真实板测：75.66 分钟 → 29.19 分钟，提速 2.59 倍；3132 个输出、板端全部迭代轨迹保持不变。原 ARM 求解器、RTL、bit 和固定矩阵均未修改，没有重新布局布线。它是独立可选的传输入口，未替换原实时程序或自动启动。详情见 `performance_20261031/README.md`，数值记录见 `reports/performance_comparison.json`。

当前仍未实现实时视频，各通道仍运行到 1100 次上限且未达到外层收敛阈值。速度提高不代表恢复质量改善；后续主要瓶颈已转为 FPGA Gx/TV 等待。

## 最新验收：2026-10-31 完整 RGB 上板结果

同一张冻结实拍 RAW 的 R/G/B 三通道已完成真实 ARM+FPGA 重构，每通道 1100 次迭代。全部 3132 个输出与 CPU 整数参考逐项完全一致，最大绝对差为 0；迭代步长、回溯次数与 TV 轮数也一致。浮点代价值存在约 1e-8 的平台舍入差异，校验中单独记录，未称为轨迹字节相同。

R/G/B 分别耗时 1504.55 / 1531.87 / 1502.94 秒，串行计算合计约 75.66 分钟（红通道来自上一批，绿、蓝来自本批）。各通道都运行到 1100 次上限，外层停止阈值尚未达到；不能把到达上限写成收敛。当前是保存 RAW 的静态上板复现，尚未接入实时摄像头，也未把新核结果接回 HDMI。

- `reports/physical_rgb_full_comparison.png`：真实板端 RGB、CPU 整数参考、全零数值差值。
- `reports/physical_rgb_vs_matlab.png`：与原 MATLAB double 结果并排比较，采用同一 RGB 显示比例；仍有模糊、形变与伪影，不能据此声称达到论文效果。
- `reports/physical_rgb_display_physical_aspect.png`：便于直接查看的 RGB 结果。
- `reports/physical_rgb_result.mat`：`X_board`、`X_cpu`、`X_matlab`、验收记录与统一显示比例；矩阵均为 29×36×3。
- `reports/physical_rgb_full_comparison.json`：逐通道数值、时间、控制路径与收敛状态。
- `reports/rgb_board_end_health.log`：计算结束后四核在线、无活动求解进程、无本次开机总线错误。

本批开始时板子已重新启动，因此重新暂停原显示客户端、加载缓冲区模块并经 JTAG 临时下载同一份已通过布局布线的 bit，再通过 Gx/TV 自检后继续 G/B；没有重跑红通道，也没有修改算法、RTL 或 bit。两批的 boot_id 保留在逐通道记录中。新 bit 未写入启动介质，旧显示/自动启动文件未覆盖；当前计算已空闲，显示客户端仍为测试暂停状态。

后续工作是加速寄存器和数据传输、接回 HDMI/OBS，再接入新采集帧与场景质量验证。当前完整算法的串行耗时远未达到实时视频要求。

## 数据和计算路径

- 固定 A 来自 `F:\fpga\PenumbraSight_MATLAB_RAW_20261030\output\A_measured.mat`，16384×1044。
- 原始实拍来自冻结结果记录的 5472×3648 BayerGB12 彩条 RAW。本次没有加入黑场、白场校正，也没有使用目标原图来生成结果。
- 与论文源码相同：`B = Diff*A`，预计算 `G=B'*B` 和 `bias=B'*Diff*measurement`。G 是完整的 1044×1044，不是原来 64 行近似。
- ARM：最小二乘初始化、FISTA 外层、回溯线搜索、TV 内层收敛判定。默认 `--initialization arm-ls`，在 ARM 上由 G、bias 解最小二乘；本机核对 3132 个初值舍入到 Q20 后，与 MATLAB 原运算顺序导出的初值完全相同。固定 RAW 参考图使用后者；仍可指定 `--initialization exported` 复核。采用 ARM 初始化的完整 RGB 上板结果已与 CPU 整数参考完全一致。
- FPGA：DDR 读取 G，完成 Gx；完成各向同性 TV 的一轮双变量更新，保留双变量后可继续下一轮。
- 输出 29×36×RGB；方向/物理宽高拉伸属于显示步骤。算法没有拿彩条或 BU 原图作模板。

## 定点格式与源码差异

G 为有符号 64 位 Q32，x 为有符号 32 位 Q20，乘加输出为有符号 112 位 Q52。TV 对偶变量 Q28；theta Q32，动量系数 Q30。每次装载和外层动量写回都舍入到 Q20，避免 ARM 与硬件使用不同迭代点。

保留源码的两处细节：回溯和停止判定使用矩阵谱范数；`opts_proj.lambda` 在回溯时更新，外层 `step*=5` 后不直接更新。TV 动量也沿用作者先更新 t_old 再计算 beta 的顺序。TV 使用原来的相对目标变化阈值 1e-6，外层阈值 2.4e-6，上限 1100。为防程序失控，TV 额外设置 4096 次显式保护，达到保护会报错，不标记收敛。

有限精度不是逐位复现 MATLAB double。CPU 整数参考的三个通道均走到 1100 次上限，尚未满足外层停止阈值；结果保留供比较，不称为收敛验收通过。`reports/hybrid_reference_comparison.json` 和对比图记录与原 MATLAB 输出的差别。该图是电脑模型结果，不是新 FPGA 板测截图。

## 文件

| 文件 | 用途 |
|---|---|
| `matlab/export_gram_model.m` | 从原 A、实拍测量和原 LS 初始化导出固定 G、bias、初值；不覆盖已导出二进制 |
| `data/G_q32_rowmajor.bin` | G 的 8,719,488 字节小端逐行文件，装入 DMA 缓冲区 |
| `rtl/hybrid_fista_accel.v` | 顶层 AXI Lite 控制口和只读 AXI DDR 口 |
| `rtl/gram64_ddr_top.v` | 完整 Gx 流式矩阵乘法 |
| `rtl/tv_prox32.v` | 高精度 TV 单轮，可恢复对偶状态继续计算 |
| `arm/hybrid_solver.py` | ARM 求解器；可选择电脑整数参考或真实 MMIO |
| `arm/hybrid_mmio.c` / `libhybrid_mmio.so` | AArch64 原生 32 位寄存器访问；真实板测必须使用，不能改回 mmap 切片读写 |
| `arm/driver/penumbra_gram.c` | 提供 DMA-coherent G 缓冲区的 Linux 模块源码，须按板子精确内核构建和实测 |
| `sim/tb_hybrid_axil.sv` | 完整 AXI Lite+DDR+Gx+TV 仿真，拒绝未知值和未初始化数据 |
| `reports/` | 仿真、综合、参考图、数据来源和保护校验 |

## 在 Vivado 打开

整板工程：点击 **Open Project**，地址栏输入

`F:\fpga\PenumbraSight_hybrid_FISTA_20261030\vivado\board_hybrid`

选择 **board_hybrid.xpr**。打开后先点 **Open Block Design → system**，检查 `hybrid_reconstruction` 以及新增控制跨时钟模块、DDR 端口。不要给板子下载独立计算模块工程。

独立计算模块工程：文件夹

`F:\fpga\PenumbraSight_hybrid_FISTA_20261030\vivado\hybrid_fista_zu4ev`

选择 **hybrid_fista_zu4ev.xpr**，点 **Run Simulation → Run Behavioral Simulation**，启动后点击 **Run All**（默认的 1000ns 不够）。这个工程验证计算模块，不能单独代替整板 bit。完整仿真建议直接执行下列脚本。

## 复现命令（Windows PowerShell）

```powershell
& 'F:\fpga\PenumbraSight_hybrid_FISTA_20261030\scripts\run_hybrid_sim.ps1' -Full
```

预期有 `[PASS GRAM64 AXIL]`、`[PASS TV32 RESUME AXIL]`、`[PASS HYBRID AXIL]`。覆盖 1,089,936 个 G 系数、1044 个精确输出、4 轮 TV、两种 AW/W 顺序、响应停顿、4KB 边界、错误命令及恢复。它证明这些运算与寄存器协议正确，不证明现场字母恢复质量。

整板综合脚本 `scripts/build_board_hybrid.tcl`；布局布线脚本 `scripts/implement_board_hybrid.tcl`。后者会在负时序裕量或 DRC Error 存在时拒绝生成 bit。HDMI/RGMII/MDIO 约束和校准保护保存在独立 `board_support` 中，以完整 Tcl 语义执行保护检查；仍需检查整板实现报告。当前机器的第三方 IP 仓库来自原队友工程，迁移到其他电脑时须连同这些仓库一并归档。

初次综合表明两套计算核并存需要 107% LUT，因此新工程采用新核替换旧 `nlos_compute` 的配置；摄像头、HDMI、以太网与其复位通路保留。原工程和原 bit 没有改变，但新 bit 不是旧实时程序的兼容替换。

新核时钟由现有 PS PL 时钟通过 `BUFGCE_DIV` 二分频，约 49.9995 MHz，不额外占用 MMCM；实现前置脚本核对工具自动推导的二分频时钟，拒绝重复或频率不符的计算核时钟。板级薄封装是 `rtl/hybrid_fista_board_div2_bd.v`。

整板已于 2026-10-30 23:56 完成布局布线及 bit 生成：`vivado/board_hybrid/board_hybrid.bit`（7,797,810 字节）。实现后 WNS=0.216ns、WHS=0.010ns，DRC 为 0 Error，仍有原板级/IP 警告，见 `reports/board_timing_routed.rpt`、`board_drc_routed.rpt`。实现报告本身只表示当前约束下实现通过；后续 Gx/TV 板测和完整 RGB 板测已完成，见本文最新验收。

## 内核构建资料与驱动

板上当前为 Linux 5.4.0，构建标记 `#11 SMP Mon Nov 14 13:40:04 CST 2022`。已在 F 盘现有 Ubuntu 虚拟机中准备厂商 atk-zup 构建目录，并编译外部 DMA 缓冲区模块；没有替换板端内核或启动镜像。

只读串口提取的原配置已保存为 `reports/board_kernel.config`（压缩原件 `board_kernel_config.gz`）。编译器指纹为 GCC 9.2.0，现有模块 vermagic 为 `5.4.0 SMP mod_unload aarch64`。配置未启用 `CONFIG_MODVERSIONS`，因此符号 CRC 表不是本配置的强制条件，仍应优先取得对应源码/生成头文件，并核对实际 ABI 与 DMA 路径；不能仅改版本字符串冒充兼容。总线偏斜报告 94 项检查最小裕量 2.357ns。

正点原子官方 MPSoC-P4（2CG/2EG/4EV）资料入口：
https://www.openedv.com/docs/boards/fpga/zdyz-MPSOC.html

官方 A 盘（源码/文档入口）：https://pan.baidu.com/s/19xJ1W_G7fVYUtzMKE_Km_Q ，提取码 `mb13`。
官方 B 盘（工具入口）：https://pan.baidu.com/s/1cfxq6IeIAwkmMYg56Pacqw ，提取码 `ub0t`。

优先查找 A 盘内嵌入式 Linux 的 `linux-xlnx` 源码、PetaLinux 工程和与板上镜像对应的构建输出（`.config`、`Module.symvers`、生成的内核头文件）；不必先下载视频或全部工具。公开教材中也出现旧 4.19 内核，不能仅按开发板型号就判定兼容当前 5.4.0。取得源码后还须核对配置、符号版本和交叉编译环境。下载保存到 F 盘；不能确认匹配前不加载驱动、不更换原启动镜像。

2026-10-31 更新：用户提供 `F:\BaiduNetdiskDownload\【正点原子】MPSoC-P4开发板资料盘（A盘）.zip` 后，已按需提取 Linux 子包，没有解压整个资料盘。源码保存在 `kernel_support/official_A/alientek-linux-v5.4-2020.2.tar.gz`；另保留 `atk-zup-linux-xlnx.tar.gz` 候选。前者顶层 Makefile 确认版本为 5.4.0，`xilinx_zynqmp_defconfig` 的全部显式配置项均与提取的板端配置一致。详情和 SHA256 见 `kernel_support/official_A/source_check.json`。这证明来源与配置方向一致，不代表已确认二进制 ABI 或完成驱动构建。配套示例 Image 也是 5.4.0 / GCC 9.2.0，但构建日期是 2024 年，与板上 2022 年镜像不同。

实际构建采用 `atk-zup-linux-xlnx.tar.gz`，因为首份 alientek 源码缺少多项板端厂商配置。构建环境为 `/home/ubuntu/penumbrasight_hybrid_20261031`，位于 F 盘现有 Ubuntu 虚拟机。使用板端配置，差异仅为 GCC 9.2.0/9.2.1 补丁版本及本缓冲区模块未使用的 IMX415、OS05A10 传感器驱动选项；见 `reports/driver_config_changes.json`。

## 上板前后

1. 以 `reports/board_integration_pass.txt`、`board_synthesis_pass.txt` 和实际 routed/bit 报告分别确认接入、综合、布局布线状态；没有文件就表示相应验收未完成。
2. `arm/driver/penumbra_gram.ko` 已编译，且在板端普通 insmod（无强制参数）加载成功，16MiB DMA 分配及 4096 字节读写通过；见 `reports/driver_board_validation_retry.log`。这仅验证缓冲区驱动，不等于整幅重构通过。
3. 下载新 bit 前，停止原来的 FPGA 实时应用，避免它访问已移除的旧核。新 bit 加载成功后，先只读检查控制基址 `0xA2000000` 的 ID，预期 `0x48594631`。新配置没有 `0xA1000000` 旧核；恢复原 bit 后才运行原实时应用。
4. 确认 PS HP0 DMA 地址路径无未匹配的 SMMU 映射，再加载缓冲区驱动，由驱动申请 DDR；不要随意选择物理地址写入 G。
5. 真实 FPGA 的整份 Gx（1044 个输出）和四轮 TV 已逐位通过，见 `reports/physical_hybrid_native_selftest.log`。首次 Python mmap 切片访问版本曾触发 SError/内核 panic，失败日志保留为 `physical_hybrid_selftest_failed_mmap.log`；冷启动恢复后采用 `arm/hybrid_mmio.c` / `libhybrid_mmio.so` 单次 32 位 volatile LDR/STR，并在下载前保留静态 GPIO/时钟驱动、仅停止显示和 DMA 客户端，复测通过。反汇编见 `mmio_disassembly.txt`。运行示例（Linux 板端，确认新 bit/内核驱动后）：

```bash
python3 arm/hybrid_solver.py --control-base 0xA2000000 --dma-device /dev/penumbra_gram --self-test
python3 arm/hybrid_solver.py --control-base 0xA2000000 --dma-device /dev/penumbra_gram --channel 0
```

加载、硬件 ID、维数、缓冲区大小/地址、G 哈希和结果均有检查。脚本不会自动下载 FPGA。先验证单次 Gx/TV 板测，再运行 RGB 完整重构。完整 1100 次迭代实测每通道约 25 分钟，本阶段没有达到实时帧率。

本脚本读取本目录固定 RAW 导出的测量向量，不自动连接实时摄像头；结果保存为板端 `reports/hybrid_FPGA_HYF1_channel*.npy` 和迭代 JSON。把三通道结果接回 HDMI/OBS 是之后的联调步骤。缓冲区驱动保持已分配内存到模块卸载为止；确认核心停止后再卸载，超时则先复位硬件。

**本轮要理解什么：** A 预先计算后，FPGA 不必保存整个 A 到片上 ROM；G 常驻安全分配的 DDR，ARM 管理论文迭代，FPGA 提供经过接口仿真的计算结果。模块仿真通过、整板实现通过、真实上板通过，是三个不同验收。

此前红通道批次记录：同一张实拍 RAW 红通道 20 次完整 ARM+FPGA 外层迭代与 CPU 整数参考完全相同（1044 样本，最大绝对差 0），见 `physical_smoke20_comparison.json`。按约 20 多分钟一批拆分：红通道运行到 1100 次上限，耗时 1504.55 秒（约25.1分钟），未达到停止阈值；1044 个结果与 CPU 整数模型完全相等，最大差 0。该批结束时绿/蓝尚未启动；之后已分别完成，见本文最新 RGB 验收。红通道记录仍保留为 `physical_red_full_comparison.json`、`physical_red_full_comparison.png`。
当前新 bit 是临时 JTAG 配置，旧显示/自动启动父进程为本次试验暂停，没有覆盖启动文件。断电后会回到原来的启动流程；当前新核不兼容旧 A1000000 实时程序。摄像头实时接入与 HDMI 输出适配仍是之后步骤。

三通道上板结果文件：`reports/board_hybrid_FPGA_HYF1_channel0_raw1100.npy`、`channel1_raw1100.npy`、`channel2_raw1100.npy`（后两者沿用相同的 `board_hybrid_FPGA_HYF1_` 前缀）；对应完整轨迹为同名 `.json`，不是相机实时帧。当前批状态为 COMPLETE，无需再次启动这些通道；启动脚本会拒绝覆盖已有通道。当前所有结果只证明与对应整数模型数值一致，不代表与 MATLAB double 逐位相同，也不代表光学恢复质量达到原论文。

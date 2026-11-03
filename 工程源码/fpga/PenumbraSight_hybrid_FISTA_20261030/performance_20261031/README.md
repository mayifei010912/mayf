# C 批量 MMIO 性能版本（2026-10-31）

这是独立性能实验，不替换 `../arm/hybrid_solver.py`、原生单寄存器库、RTL、bit、固定矩阵、原实时程序或启动文件。

## 实测结果

| 项目 | 已验证旧版 | C 批量读写版 |
|---|---:|---:|
| 红通道 1100 次，含 ARM 初始化 | 25.08 分钟 | 9.70 分钟 |
| 绿通道 1100 次，含 ARM 初始化 | 25.53 分钟 | 9.82 分钟 |
| 蓝通道 1100 次，含 ARM 初始化 | 25.05 分钟 | 9.67 分钟 |
| 完整 RGB | 75.66 分钟 | 29.19 分钟 |

完整 RGB 提速 2.5917 倍。3132 个输出与旧版真实板端输出、CPU 整数参考逐项完全相同；同一板端的全部迭代轨迹也完全相同。每通道仍运行到 1100 次上限，尚未达到外层收敛阈值。当前处理保存的固定 RAW，不是实时相机。

20 次迭代剖析：总求解时间 28.626 → 11.030 秒；装载/读回/控制及转换合计 18.838 → 1.243 秒；Gx/TV 等待约 9.385 秒保持不变；ARM 数学与调度约 0.402 秒。初始化约 4.08 秒，单独计时。上述短测试含轻量计时包装；完整测试无该包装。

## 改动范围

- `hybrid_bulk_mmio.c` / `libhybrid_bulk_mmio.so`：向量装载与输出读回的循环移到 C，每次设备访问仍使用 volatile 32 位 LDR/STR 与 DSB；没有设备 memcpy，没有省略或合并命令。
- `fast_mmio.py`：继承已验证的 `MMIOCore`，仅替换传输方法。Gx 保留有符号 128 位读回，再以与旧版相同的方式转换；TV 输出保持 Q20。
- `profile_baseline.py` / `profile_fast.py`：20 次短测试与耗时分解；新版本先通过完整 Gx 和四轮 TV 自检。
- `run_fast_rgb.py`：调用原来的 `reconstruct_channel`，算法、初始化、矩阵、线搜索、TV 和停止规则均不修改。G 在同一次进程内常驻驱动分配的 DMA 缓冲区。
- `protected_baseline_manifest.json`：22 个已验证 ARM/RTL/MATLAB 文件的保护校验。原 bit 的 SHA256 也已核对。

板端实验路径为 `/root/nlos_stage2/hybrid_fista_20261031/performance_20261031`。只有确认新 HYF1 bit、驱动和暂停显示的测试配置已就绪，才能使用 `FastMMIOCore`。现有旧 A1000000 实时程序不适用于当前新 bit。测试入口拒绝覆盖已有输出，不能把重复执行当成实时运行模式。

## 结果位置

- `../reports/performance_comparison.json`：全部时间、逐通道差值、轨迹与保护校验。
- `../reports/performance_comparison.png`：耗时分解及完整运行前后比较。
- `../reports/board_fast_channel0_output.npy`（及 channel1、channel2）：本次真实板端输出，29×36。
- `../reports/board_fast_channel0_trace.json`（及 channel1、channel2）：完整轨迹。
- `../reports/board_fast_rgb_summary.json`：板端完整运行计时。
- `../reports/board_performance_end_health.json`：四核在线、驱动加载、无本次开机总线错误，以及板端原求解器/矩阵哈希。
- `build_bulk_mmio.sh` / `bulk_mmio_disassembly.txt`：交叉编译与反汇编记录，使用原来的 Arm GCC 9.2.1 环境。

这一步只提速，不改变恢复质量。优化后短测试约 85% 求解时间仍在等待 Gx/TV；进一步大幅提速需要检查 FPGA 矩阵访存和计算结构，并单独验证迭代策略的质量代价。

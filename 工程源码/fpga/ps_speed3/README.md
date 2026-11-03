# 已验证并启用的speed3工程

Vivado 2020.2打开：`F:\fpga\ps_speed3\vivado\board_hybrid\board_hybrid.xpr`。

实际新bit是`vivado/board_hybrid/board_speed3.bit`，SHA256 `2473c7d7d7d82d443a3cc5d879bd0518542f63466542ada63c8e15cca7aaeb4d`。同目录其他bit是独立工程创建时复制的旧文件，app明确使用board_speed3.bit。

新增`rtl/fixed_g_axi_reader_queued.v`，八个16-beat、4KB安全的读取请求交叠，按原顺序送出64位系数；错误时排空已接受请求。`gram64_ddr_top.v`选择此读取器，`hybrid_fista_board_div2_bd.v`声明8个outstanding读请求。矩阵乘流水线、112位累加、50MHz、矩阵、TV、ARM算法、寄存器及1100次上限保持不变。

构建入口`scripts/build_speed3.tcl`；最终路由DCP为`reports/board_speed3_routed.dcp`。最终WNS=0.152ns、WHS=0.010ns，无DRC Error；读取器异常/停顿、完整Gx及四轮TV仿真通过。整张真实RAW三通道实测682.815秒，全部3132值和完整迭代轨迹与speed2精确一致。

验证、启用与回退记录：`F:\fpga\PenumbraSight_speed_stage3_20261101`。完整21.4分钟版本备份：`F:\fpga_backups\PenumbraSight_speed2_20261101_013529`。新工程仍引用原团队IP仓库，转移到其他电脑需连同依赖整理，不能只复制xpr。

## MacOS上进行Verilog仿真
## Verilog Simulation on MacOS
#### 2021.7.16 Luke 
### Preface
MacOS系统一向以开发者友好而著称，然而对于Verilog开发者来说，macOS上没有对应的Vivado、ModelSim等软件，这是极大的不便。本文档将介绍基于代码编辑器VScode、Verilog仿真工具Icarus Verilog和波形查看器gtkwave的Verilog波形仿真方法。这里给出的代码样例为利用动态规划的方法求解背包问题，并利用7段码扫描显示16进制的结果。

### 前期准备
#### 1.下载VScode

直接在官网下载即可。

#### 2.安装Icarus Verilog

使用Homebrew安装，在终端中输入：
```zsh
brew install icarus-verilog
```
其它合理安装方式均可。

#### 3.安装gtkwave

在官网下载或者利用Homebrew安装。如果利用Homebrew安装，在终端中输入：
```zsh
brew install gtkwave
```
在终端输入gtkwave，如果成功打开gtkwave则无需额外操作，如果不成功，则把Unix可执行文件 /Applications/gtkwave.app/Contents/Resources/bin/gtkwave拷贝到/usr/local/bin/文件夹中即可。

#### 4.修改Verilog代码

将所有.v文件放在同一目录下。在每个文件开头include该文件中例化其他模块涉及的全部.v文件，否则编译将显示找不到对应的文件。也可在对应模块的代码开头include该模块中例化的其它模块的.v文件。代码示例中采取第一种方法，因此在Backpack_tb.v中加入：
```verilog
`include "top.v"
```
在top.v中加入：
```verilog
`include "BCD7.v"
`include "Scanner.v"
`include "Backpack.v"
```

在testbench文件Backpack_tb.v内（Backpack_tb.v）加入如下生成波形文件的代码：
```verilog
/*iverilog */
initial begin
	$dumpfile("Backpack.vcd");//产生波形文件
	$dumpvars(0,Backpack_tb);//也可直接写为$dumpvars;
    #500 //仿真时间
	$finish;
end
/*iverilog */
```
以上代码将控制iverilog生成波形文件Backpack.vcd。注意其中仿真时间必不可少，因为如果不写则得到的波形时长为0s，也就是没有波形。仿真时间的单位可在timescale语句中修改。

testbench文件Backpack_tb.v完整代码：
```verilog
`timescale 1ns/100ps
`include "top.v"

module Backpack_tb();
reg clk,reset;
wire [15:0] max_value;
wire [7:0] cathodes;
wire [3:0] ano;

initial begin
    clk <= 0;
    reset <= 1;
    #10
    reset <= 0;
end

always begin//时钟信号
    #5 
    clk <= ~clk; 
end

top mytop(clk,reset,ano,cathodes);

/*iverilog */
initial begin
	$dumpfile("Backpack.vcd");//产生波形文件
	$dumpvars(0,Backpack_tb);
	#500 //仿真时间
	$finish;
end
/*iverilog */

endmodule
```

### 波形仿真Method 1: 使用Vscode中HDL插件

在Vscode中搜索并下载Verilog HDL插件：

![Verilog HDL](https://github.com/Lukeli0425/Verilog-Simulation-on-MacOS/raw/main/Verilog%20HDL.jpg)

之后打开testbench模块backpack_tb.v，点击右上角的绿色图标进行编译：

![Operate HDL](https://github.com/Lukeli0425/Verilog-Simulation-on-MacOS/raw/main/Operate%20HDL.jpg)

此时如果编译出错，错误信息会在下方的输出中显示；如果编译成功并且波形文件产生成功，输出中会显示：

```shell
[Running] Backpack_tb.v
VCD info: dumpfile Backpack.vcd opened for output.
[Done] exit with code=0 in 0.072 seconds
```
此后直接用gtkwave打开波形文件Backpack.vcd查看波形即可。在左侧选择需要查看的信号，点击append或insert加入信号视图查看：

![Wave](https://github.com/Lukeli0425/Verilog-Simulation-on-MacOS/raw/main/wave.jpg)

注意，使用这个插件仍需要下载Icarus Verilog，因此本质上它仍是使用Icarus Verilog进行编译和产生波形文件，只是比较方便快捷。

### 波形仿真Method 2: 在终端中运行脚本文件
这个方法同样利用Icarus Verilog生成波形文件,因此前述在Verilog代码中添加的iverilog命令在这种方法下不能被省略。编写如下的脚本文件 wave.sh：
```zsh
echo "开始编译"
iverilog -o Backpack.vvp Backpack_tb.v 
echo "编译完成"

echo "生成波形文件"
vvp -n Backpack.vvp

echo "打开波形文件"
gtkwave Backpack.vcd 
```
在终端中使用cd命令进入所有.v文件所在的目录（需要的全部文件都要在此目录下），运行脚本 wave.sh，自动产生波形文件，并自动打开gtkwave，可以直接查看。

### Files

    wave.sh             生成波形的脚本文件
    Backpack_tb.v       testbench模块
    top.v               顶层模块
    Backpack.v          背包问题计算模块
    BCD7.v              16进制7段译码器模块
    Scanner.v           扫描模块
    bp.xdc              约束文件（使用Ego1开发板时会用到）
    Backpack.vvp        vvp文件
    Backpack.vcd        仿真波形文件
    Verilog HDL.jpg     Verilog HDL插件截图
    Operate HDL.jpg     VScode使用HDL插件界面截图
    wave.jpg            使用gtkwave查看波形界面截图
    README.md           说明文档

### References
知乎文章：[全平台开源EDA工具——MacOS下也能做Verilog开发/仿真/综合](https://zhuanlan.zhihu.com/p/151433928)

VScode官网（可下载Vscode，查看官方文档）：[Visual Studio Code](https://code.visualstudio.com)

Icarus Verliog主页：[Icarus Verliog](http://iverilog.icarus.com)

gtkwave主页：[gtkwave](http://gtkwave.sourceforge.net)

#### Contact me: lukeli@sina.cn

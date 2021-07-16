## MacOS上进行verilog仿真
## Verilog Simulation on MacOS
#### 2021.7.16 luke 
### Preface
MacOS系统一向以开发者友好而著称，然而对于Verilog开发者来说，macOS上没有对应的Vivado、ModelSim等软件，这是极大的不便。本文档将介绍基于代码编辑器VScode、Icarus Verilog和波形查看器gtkwave的verilog波形仿真方法。给出的代码样例为利用动态规划的方法求解背包问题，并利用7段码扫描显示16进制的结果。

### 前期准备
#### 1.下载VScode

直接在官网下载即可。

#### 2.安装Icarus Verilog

利用Homebrew安装，在终端中输入：
```zsh
brew install icarus-verilog
```
即可安装。其它合理安装方式均可。

#### 3.安装gtkwave

在官网下载或者利用Homebrew安装。如果利用Homebrew安装，在终端中输入：
```zsh
brew install gtkwave
```
在终端输入gtkwave，如果成功打开gtkwave则无需额外操作，如果不成功，则可以把Unix可执行文件 /Applications/gtkwave.app/Contents/Resources/bin/gtkwave拷贝到/usr/local/bin/文件夹中即可。

#### 4.修改Verilog代码

在文件开头include用到的全部.v文件，否则编译将显示找不到对应的文件。也可在对应模块的代码开头include该模块中例化的其它模块的.v文件。代码示例中采取第一种方法，textbench模块中：
```verilog
`include "top.v"
```
顶层模块中：
```verilog
`include "BCD7.v"
`include "Scanner.v"
`include "Backpack.v"
```

在testbench模块内（Backpack_tb.v）加入如下生成波形文件的代码：
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

testbench完整代码：
```verilog
`timescale 1ns/100ps
`include "top.v"

module Backpack_tb();
reg clk,res;
wire [15:0] max_value;
wire [7:0] cathodes;
wire [3:0] ano;

initial begin
    clk <= 0;
    res <= 1;
    #10
    res <= 0;
end

always begin//时钟信号
    #5 
    clk <= ~clk; 
end

top mytop(clk,res,ano,cathodes);

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

### Method 1: 使用Vscode中HDL插件

在Vscode中搜索并下载Verilog HDL插件：

[image](截屏2021-07-16 12.45.37.png)
```shell
[Running] Backpack_tb.v
VCD info: dumpfile Backpack.vcd opened for output.
[Done] exit with code=0 in 0.072 seconds
```
### Method 2: 使用终端命令行
这个方法同样利用Icarus Verilog生成波形文件,因此前述在verilog代码中添加的iverilog命令在这种方法下不能被省略。编写如下的脚本文件 wave.sh：
```zsh
echo "开始编译"
iverilog -o Backpack.vvp Backpack_tb.v 
echo "编译完成"

echo "生成波形文件"
vvp -n Backpack.vvp

echo "打开波形文件"
gtkwave Backpack.vcd 
```
在终端进入.v文件所在的目录（需要的全部文件都要在此目录下），运行脚本 wave.sh，则


### Files

    Wave.sh             生成波形的脚本文件
    Backpack_tb.v       testbench模块
    top.v               顶层模块
    Backpack.v          背包问题计算模块
    BCD7.v              16进制7段译码器模块
    Scanner.v           扫描模块
    bp.xdc              约束文件（使用Ego1开发板）
    Backpack.vvp        
    Backpack.vcd        仿真波形文件
    README.md           说明文档

### References
知乎文章：[全平台开源EDA工具——MacOS下也能做Verilog开发/仿真/综合](https://zhuanlan.zhihu.com/p/151433928)

VScode官网，可下载Vscode，查看官方文档：[Visual Studio Code](https://code.visualstudio.com)

Icarus Verliog主页：[Icarus Verliog](http://iverilog.icarus.com)

gtkwave主页：[gtkwave](http://gtkwave.sourceforge.net)


// 2021-7-1 luke Backpack_tb
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
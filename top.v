// 2021-7-11 luke
`timescale 1ns/100ps

`include "BCD7.v"
`include "Scanner.v"
`include "Backpack.v"

module top(clk,res,ano,cathodes);
//signals
input clk,res;
output [3:0] ano;
output [7:0] cathodes;
wire [15:0] ans;
wire [3:0] digit;//显示位

//例化
Scanner myScanner(clk,res,ans,ano,digit);
BCD7 myBCD(digit,cathodes);
Backpack myBachpack(clk,res,ans);

endmodule
// 2021-7-11 luke 背包问题
`timescale 1ns/100ps

module Backpack(clk,res,max_value);
//输入输出
input clk,res;
output[15:0] max_value;

//定义需要的变量
// reg [9:0] bag_size;
// reg [9:0] goods_number;
reg [9:0] weight[0:4];
reg [9:0] value[0:4];
reg [15:0] dp[0:goods_number][0:bag_size];
reg [9:0] i,j;//双重循环的循环变量，用计数器实现
integer l,m;

parameter bag_size = 8;//背包容量
parameter goods_number = 4;//物品数量

always@(posedge clk or posedge res) begin
    if(res) begin
        i <= 1; j <= 1;
        weight[0] <= 0; value[0] <= 0;
        weight[1] <= 2; value[1] <= 3;
        weight[2] <= 3; value[2] <= 4;
        weight[3] <= 4; value[3] <= 5;
        weight[4] <= 5; value[4] <= 6;
        for(l=0; l < goods_number+1; l=l+1)
            for(m=0; m < bag_size+1; m=m+1)
                dp[l][m] <= 0;//状态转移表
    end
    else begin
        //动态规划算法
        if(j < weight[i]) begin
            dp[i][j] <= dp[i - 1][j];
        end
        else  begin
            dp[i][j] <= (dp[i-1][j] > (dp[i-1][j-weight[i]] + value[i])) ? dp[i-1][j]:(dp[i-1][j-weight[i]] + value[i]);
        end
        
        //计数器
        if(j == bag_size) begin
            j <= 1;
            if(i == goods_number) begin
                i <= 1;
            end
            else begin
                i <= i+1;
            end
        end
        else begin
            j <= j+1;
        end
    end
end

assign max_value = dp[goods_number][bag_size];

endmodule
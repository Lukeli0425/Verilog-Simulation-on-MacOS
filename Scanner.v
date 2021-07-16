//2021-7-11 luke Scanner
//扫描模块
`timescale 1ns/100ps

module Scanner(clk,res,ans,ano,digit);
input clk,res;
input [15:0] ans;
output reg [3:0] ano;
output reg [3:0] digit;

initial begin
    ano <= 4'b0001;
    digit <= 0;
end

always@(posedge clk or posedge res) begin
    if(res) begin
        ano <= 4'b0001;
    end
    else begin
        case(ano)
            4'b0001: begin ano <= 4'b0010; end
            4'b0010: begin ano <= 4'b0100; end
            4'b0100: begin ano <= 4'b1000; end
            4'b1000: begin ano <= 4'b0001; end
            default: begin ano <= 4'b0001; end
        endcase
    end
end

always@(*) begin
    case(ano)
        4'b0001: begin digit <= ans[3:0]; end
        4'b0010: begin digit <= ans[7:4]; end
        4'b0100: begin digit <= ans[11:8]; end
        4'b1000: begin digit <= ans[15:12]; end
        default: begin digit <= ans[3:0]; end
    endcase
end

endmodule
    
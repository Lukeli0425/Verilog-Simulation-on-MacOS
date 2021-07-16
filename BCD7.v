//2021-7-11 luke bcd7(hex)
`timescale 1ns/100ps

module BCD7(digit,cathodes);
input [3:0] digit;
output reg [7:0] cathodes;

always@(*) begin
    case(digit)
        0: begin cathodes<=8'b0111_1110; end
        1: begin cathodes<=8'b0000_1100; end
        2: begin cathodes<=8'b1011_0110; end
        3: begin cathodes<=8'b1001_1110; end
        4: begin cathodes<=8'b1100_1100; end
        5: begin cathodes<=8'b1101_1010; end
        6: begin cathodes<=8'b1111_1010; end
        7: begin cathodes<=8'b0000_1110; end
        8: begin cathodes<=8'b1111_1110; end
        9: begin cathodes<=8'b1101_1110; end
        10: begin cathodes<=8'b1110_1110; end
        11: begin cathodes<=8'b1111_1000; end
        12: begin cathodes<=8'b1011_0000; end
        13: begin cathodes<=8'b1011_1100; end
        14: begin cathodes<=8'b1111_0010; end
        15: begin cathodes<=8'b1110_0010; end
        default: begin cathodes<=8'b0000_0000; end
    endcase
end

endmodule
`timescale 1ns/1ps

module alu ( input wire a,
input wire b,
input wire c,
input wire [2:0] s,
output reg o
);

always @(*)begin
case(s)
3'b000: o = ~(b & c);
3'b001: o = ~(b | c);
3'b010: o =  (b & c);
3'b011: o =  (b | c);
3'b100: o =  (b ^ c);
3'b101: o =  ((a^b)^c);
3'b110: o = (((a ^ b) & c) | (a & b));
3'b111: o = ~(a);
endcase
end

endmodule

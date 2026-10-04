`timescale 1ns/1ps
module tb_alu;

reg a;
reg b;
reg c;
reg [2:0] s;
wire o;

alu one (.a(a), .b(b), .c(c), .s(s), .o(o));

initial begin
    a = 0; b = 1; c = 1;
    
$display("A B C | S2 S1 S0 | O");

    for (integer i = 0; i < 8; i = i + 1) begin
        s = i[2:0];
        #10;
        $display("%b %b %b |  %b  %b  %b | %b", a, b, c, s[2], s[1], s[0], o);
    end
    $finish;
end

endmodule

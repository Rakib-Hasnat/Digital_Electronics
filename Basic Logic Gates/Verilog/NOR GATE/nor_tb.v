`timescale 1ns / 1ps
module nor_gate_tb;
 
 reg A,B;
 wire X,Y,Z;

 nor_gate uut (
    .A(A),
    .B(B),
    .X(X),
    .Y(Y),
    .Z(Z)
 );
 initial begin 
 $dumpfile("wave.vcd");
 $dumpvars(0, nor_gate_tb);
 end

 reg clk;
 initial clk = 0;
 always #5 clk = ~clk;

 always @(posedge clk) begin
 A <= $random & 1'b1;
 B <= $random & 1'b1;
 end    

 initial begin
    #100 $finish;
    end

endmodule
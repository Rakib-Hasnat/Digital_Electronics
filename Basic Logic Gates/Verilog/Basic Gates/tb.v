`timescale 1ns/1ps

module tb_exp_01;

reg a,b;
wire t,u,v,w,x,y,z;

exp_01 any (
    .a(a),
    .b(b),
    .t(t),
    .u(u),
    .v(v),
    .w(w),
    .x(x),
    .y(y),
    .z(z)
);


reg clk;
initial clk =0;
always #5 clk = ~clk;


always@(posedge clk)
begin
    a<= $random %2;
    b<= $random %2;
end


initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_exp_01);
end


initial begin
#100 $finish;
end


endmodule
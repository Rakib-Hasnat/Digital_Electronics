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
#100 report_and_finish;
end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(a or b) begin
        #1;
        checks = checks + 1;
        if (({t,u,v,w,x,y,z}) !== ({a&b, a|b, ~a, ~(a|b), ~(a&b), a^b, ~(a^b)})) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: a=%b b=%b got %b expected %b", $time, a, b, ({t,u,v,w,x,y,z}), ({a&b, a|b, ~a, ~(a|b), ~(a&b), a^b, ~(a^b)}));
        end
    end

    task report_and_finish;
        begin
            if (errors == 0) $display("PASS: %0d checks", checks);
            else             $display("FAIL: %0d of %0d checks failed", errors, checks);
            $finish;
        end
    endtask

endmodule

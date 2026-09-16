`timescale 1ns/1ps

module d_type_tb;

    reg clk, d, pr, cr;
    wire q, q_bar;

    d_type dut (
        .clk(clk), .d(d), .pr(pr), .cr(cr),
        .q(q), .q_bar(q_bar)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("d_type_tb.vcd");
        $dumpvars(0, d_type_tb);

        d = 0;

        pr = 1; cr = 1; #10;   // normal
        pr = 0; cr = 1; #10;   // preset
        pr = 1; cr = 0; #10;   // clear
        pr = 1; cr = 1; #10;   // back to normal

        repeat (10) begin
            d = $random;
            #10;
        end

        #10 $finish;
    end

endmodule

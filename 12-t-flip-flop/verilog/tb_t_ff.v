
`timescale 1ns/1ps

module t_type_tb;

    reg clk, t, pr, cr;
    wire q, q_bar;

    t_type dut (
        .clk(clk), .t(t), .pr(pr), .cr(cr),
        .q(q), .q_bar(q_bar)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("pr cr t | q q_bar");
        $monitor("%b  %b  %b |  %b   %b", pr, cr, t, q, q_bar);

        pr = 1; cr = 1; t = 0; #10;
        pr = 1; cr = 1; t = 0; #10;
        pr = 1; cr = 1; t = 1; #10;
        pr = 0; cr = 1; t = 0; #10;
        pr = 1; cr = 1; t = 0; #10;
        pr = 1; cr = 0; t = 0; #10;
        pr = 1; cr = 1; t = 0; #10;
        pr = 1; cr = 1; t = 1; #10;

        $finish;
    end

endmodule

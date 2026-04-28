`timescale 1ns/1ps

module tb_jk_ms_ff;

    reg  j, k, clk;
    reg  pre_bar, clr_bar;
    wire q, q_bar;

    jk_ms_ff uut (
        .j       (j      ),
        .k       (k      ),
        .clk     (clk    ),
        .pre_bar (pre_bar),
        .clr_bar (clr_bar),
        .q       (q      ),
        .q_bar   (q_bar  )
    );

    // Clock: 20ns period
    initial clk = 0;
    always #10 clk = ~clk;

    // VCD dump for GTKWave
    initial begin
        $dumpfile("jk_ms_ff.vcd");
        $dumpvars(0, tb_jk_ms_ff);
    end

    // --------------------------------------------------------
    // Truth Table
    // --------------------------------------------------------
    initial begin
        pre_bar = 1; clr_bar = 1; j = 0; k = 0;

        // Hold clr_bar low for full clock cycle to flush x from both latches
        clr_bar = 0; #30; clr_bar = 1;
        #10;
        @(negedge clk);

        $display("");
        $display("  J  K  |  Q    Q_bar  | Operation");
        $display("--------------------------------------");

        // HOLD (Q was 0)
        j=0; k=0; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | HOLD", j, k, q, q_bar);

        // SET
        j=1; k=0; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | SET", j, k, q, q_bar);

        // HOLD (Q was 1)
        j=0; k=0; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | HOLD", j, k, q, q_bar);

        // RESET
        j=0; k=1; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | RESET", j, k, q, q_bar);

        // TOGGLE (0 → 1)
        j=1; k=1; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | TOGGLE", j, k, q, q_bar);

        // TOGGLE (1 → 0)
        j=1; k=1; @(negedge clk); #2;
        $display("  %b  %b  |  %b      %b    | TOGGLE", j, k, q, q_bar);

        $display("--------------------------------------");
        $display("");

        // Async PRE test
        pre_bar = 0; #15;
        $display("  PRE_bar=0 → Q=%b  Q_bar=%b  (expect Q=1)", q, q_bar);
        pre_bar = 1; #20;

        // Async CLR test
        clr_bar = 0; #15;
        $display("  CLR_bar=0 → Q=%b  Q_bar=%b  (expect Q=0)", q, q_bar);
        clr_bar = 1;
        $display("");
    end

    // --------------------------------------------------------
    // Random Sequence for GTKWave
    // --------------------------------------------------------
    integer seed = 42;
    integer i;

    initial begin
        #400;

        $display("  J  K  |  Q    Q_bar  | (random sequence)");
        $display("--------------------------------------");

        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
            j = $random(seed) % 2;
            k = $random(seed) % 2;
            @(negedge clk); #2;
            $display("  %b  %b  |  %b      %b    |", j, k, q, q_bar);
        end

        $display("--------------------------------------");
        $display("Done. Open jk_ms_ff.vcd in GTKWave.");
        $finish;
    end

endmodule
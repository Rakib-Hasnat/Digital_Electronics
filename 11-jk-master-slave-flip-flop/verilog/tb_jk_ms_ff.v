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
    // Self-check helper: Q must equal the expected value and
    // Q_bar must be its complement.
    // --------------------------------------------------------
    integer errors = 0, checks = 0;
    reg q_prev;

    task check;
        input q_expected;
        begin
            checks = checks + 1;
            if (q !== q_expected || q_bar !== ~q_expected) begin
                errors = errors + 1;
                $display("FAIL at t=%0t: Q=%b Q_bar=%b, expected Q=%b", $time, q, q_bar, q_expected);
            end
        end
    endtask

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
        j=0; k=0; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | HOLD", j, k, q, q_bar);
        check(1'b0);

        // SET
        j=1; k=0; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | SET", j, k, q, q_bar);
        check(1'b1);

        // HOLD (Q was 1)
        j=0; k=0; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | HOLD", j, k, q, q_bar);
        check(1'b1);

        // RESET
        j=0; k=1; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | RESET", j, k, q, q_bar);
        check(1'b0);

        // TOGGLE (0 → 1)
        j=1; k=1; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | TOGGLE", j, k, q, q_bar);
        check(1'b1);

        // TOGGLE (1 → 0)
        j=1; k=1; @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
        $display("  %b  %b  |  %b      %b    | TOGGLE", j, k, q, q_bar);
        check(1'b0);

        $display("--------------------------------------");
        $display("");

        // Async PRE test
        pre_bar = 0; #15;
        $display("  PRE_bar=0 → Q=%b  Q_bar=%b  (expect Q=1)", q, q_bar);
        check(1'b1);
        pre_bar = 1; #20;

        // Async CLR test
        clr_bar = 0; #15;
        $display("  CLR_bar=0 → Q=%b  Q_bar=%b  (expect Q=0)", q, q_bar);
        check(1'b0);
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
            q_prev = q;
            @(negedge clk); #5;  // slave latch settles 3-4 ns after the edge
            $display("  %b  %b  |  %b      %b    |", j, k, q, q_bar);
            check((j & ~q_prev) | (~k & q_prev));   // JK characteristic equation
        end

        $display("--------------------------------------");
        $display("Done. Open jk_ms_ff.vcd in GTKWave.");
        if (errors == 0) $display("PASS: %0d checks", checks);
        else             $display("FAIL: %0d of %0d checks failed", errors, checks);
        $finish;
    end

endmodule

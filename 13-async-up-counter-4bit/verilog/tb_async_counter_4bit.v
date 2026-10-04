`timescale 1ns/1ps

module tb_async_counter;

    reg  clk, reset;
    wire [3:0] q;

    async_counter_4bit uut (
        .clk   (clk  ),
        .reset (reset),
        .q     (q    )
    );

    // Clock: 20ns period
    initial clk = 0;
    always #10 clk = ~clk;

    // VCD dump — dumps all internal FF signals too
    initial begin
        $dumpfile("async_counter.vcd");
        $dumpvars(0, tb_async_counter);
    end

    reg [3:0] expected = 4'd0;
    integer errors = 0;

    initial begin
        // Reset
        reset = 1; #25;
        reset = 0;

        $display("");
        $display(" | QD  QC  QB  QA | Decimal");
        $display("-----------------------------");

        repeat(17) begin
            @(negedge clk); #2;
            $display(" |  %b   %b   %b   %b  |   %0d",
                      q[3], q[2], q[1], q[0], q);
            // Self-check: the count must go up by one each clock, wrapping 15 -> 0
            expected = expected + 1;
            if (q !== expected) begin
                errors = errors + 1;
                $display("FAIL: got %0d expected %0d", q, expected);
            end
        end

        $display("-------------------------------");
        $display("");

        // Run 2 full cycles for clean GTKWave view
        repeat(32) @(negedge clk);

        $display("Done. Open async_counter.vcd in GTKWave.");
        if (errors == 0) $display("PASS: 17 checks");
        else             $display("FAIL: %0d of 17 checks failed", errors);
        $finish;
    end

endmodule
`timescale 1ns/1ps

// Runs the synchronous and asynchronous T flip-flops side by side on the
// same inputs, so the difference in preset/clear timing is easy to see,
// and checks both against hand-worked expected values.
module tb_t_ff;

    reg clk = 0, t = 0, pr = 1, cr = 0;
    wire q_s, q_bar_s, q_a, q_bar_a;

    t_ff_sync  sync_ff  (.clk(clk), .t(t), .pr(pr), .cr(cr), .q(q_s), .q_bar(q_bar_s));
    t_ff_async async_ff (.clk(clk), .t(t), .pr(pr), .cr(cr), .q(q_a), .q_bar(q_bar_a));

    always #5 clk = ~clk;   // rising edges at 5, 15, 25, ... ns

    initial begin
        $dumpfile("t_ff.vcd");
        $dumpvars(0, tb_t_ff);
    end

    integer errors = 0, checks = 0;

    // Print one row and compare both flip-flops with the expected Q values
    task show;
        input exp_s, exp_a;
        input [8*24-1:0] step;
        begin
            $display("%3d ns |  %b  %b  %b |   %b       %b    | %0s", $time, pr, cr, t, q_s, q_a, step);
            checks = checks + 1;
            if (q_s !== exp_s || q_bar_s !== ~exp_s || q_a !== exp_a || q_bar_a !== ~exp_a) begin
                errors = errors + 1;
                $display("FAIL at %0d ns: sync Q=%b (expected %b), async Q=%b (expected %b)",
                         $time, q_s, exp_s, q_a, exp_a);
            end
        end
    endtask

    // Wait for the next rising clock edge, plus 1 ns for the outputs to settle
    task next_edge;
        begin @(posedge clk); #1; end
    endtask

    initial begin
        $display("  time | pr cr  t | Q sync  Q async | step");
        $display("-------+----------+-----------------+------------------------");

        // cr = 0 from the start, so both flip-flops clear on the first edge
        next_edge;                              show(0, 0, "clear");

        // Toggle mode: Q flips on every rising edge while t = 1
        @(negedge clk) begin cr = 1; t = 1; end
        next_edge;                              show(1, 1, "toggle (t=1)");
        next_edge;                              show(0, 0, "toggle (t=1)");
        next_edge;                              show(1, 1, "toggle (t=1)");

        // Hold mode: Q keeps its value while t = 0
        @(negedge clk) t = 0;
        next_edge;                              show(1, 1, "hold (t=0)");

        // Clear between clock edges: async reacts at once, sync waits for the edge
        @(negedge clk) cr = 0;  #1;             show(1, 0, "cr=0 between edges");
        next_edge;                              show(0, 0, "cr=0 at the clock edge");

        // Preset between clock edges: the same difference
        @(negedge clk) begin cr = 1; pr = 0; end
        #1;                                     show(0, 1, "pr=0 between edges");
        next_edge;                              show(1, 1, "pr=0 at the clock edge");

        // Back to normal operation
        @(negedge clk) begin pr = 1; t = 1; end
        next_edge;                              show(0, 0, "toggle (t=1)");
        @(negedge clk) t = 0;
        next_edge;                              show(0, 0, "hold (t=0)");

        if (errors == 0) $display("PASS: %0d checks", checks);
        else             $display("FAIL: %0d of %0d checks failed", errors, checks);
        $finish;
    end

endmodule

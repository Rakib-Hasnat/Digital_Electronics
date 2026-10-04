`timescale 1ns / 1ps
module adder_tb;

    // Inputs
    reg A, B, C;

    // Outputs
    wire sum_half, carry_half;
    wire sum_full, carry_full;

    // Clock
    reg clk;

    // Instantiate DUT
    adder uut (
        .A(A),
        .B(B),
        .C(C),
        .sum_half(sum_half),
        .carry_half(carry_half),
        .sum_full(sum_full),
        .carry_full(carry_full)
    );

    // Clock generation for random inputs
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform for GTKWave from the start
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, adder_tb);
    end

    // --------------------------
    // Part 1: Manual test vectors
    // --------------------------
    initial begin
        C = 0;

        $display("---- Half Adder ----");
        $display("A B | sumH carryH");
        A=0; B=0; #10; $display("%b %b | %b %b", A,B,sum_half,carry_half);
        A=0; B=1; #10; $display("%b %b | %b %b", A,B,sum_half,carry_half);
        A=1; B=0; #10; $display("%b %b | %b %b", A,B,sum_half,carry_half);
        A=1; B=1; #10; $display("%b %b | %b %b", A,B,sum_half,carry_half);

        $display("\n---- Full Adder ----");
        $display("A B C | sumH carryH | sumF carryF");
        A=0; B=0; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=0; B=0; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=0; B=1; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=0; B=1; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=1; B=0; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=1; B=0; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=1; B=1; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
        A=1; B=1; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,sum_half,carry_half,sum_full,carry_full);
    end

    // --------------------------
    // Part 2: Random inputs
    // --------------------------
    // Only after the manual vectors (delay to avoid overlap)
    initial begin
        #120; // wait for manual vectors to finish (4 half + 8 full rows x 10 ns)
        forever @(posedge clk) begin
            A <= $random & 1;
            B <= $random & 1;
            C <= $random & 1;
        end
    end



    // Stop simulation after enough time for both parts
    initial begin
        #300 report_and_finish;
    end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(A or B or C) begin
        #1;
        checks = checks + 1;
        if (({carry_half, sum_half, carry_full, sum_full}) !== ({{1'b0,A} + B, {1'b0,A} + B + C})) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: A=%b B=%b C=%b got %b expected %b", $time, A, B, C, ({carry_half, sum_half, carry_full, sum_full}), ({{1'b0,A} + B, {1'b0,A} + B + C}));
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

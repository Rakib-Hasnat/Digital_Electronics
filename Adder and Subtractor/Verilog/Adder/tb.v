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
        #100; // wait for manual vectors to finish
        forever @(posedge clk) begin
            A <= $random & 1;
            B <= $random & 1;
            C <= $random & 1;
        end
    end



    // Stop simulation after enough time for both parts
    initial begin
        #300 $finish;
    end

endmodule

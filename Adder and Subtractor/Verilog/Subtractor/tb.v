`timescale 1ns / 1ps
module subtractor_tb;

    // Inputs
    reg A, B, C;

    // Outputs
    wire diff_half, borrow_half;
    wire diff_full, borrow_full;

    // Clock
    reg clk;

    // Instantiate DUT
    subtractor uut (
        .A(A),
        .B(B),
        .C(C),
        .diff_half(diff_half),
        .borrow_half(borrow_half),
        .diff_full(diff_full),
        .borrow_full(borrow_full)
    );

    // Clock generation for random inputs
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform for GTKWave from the start
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, subtractor_tb);
    end

    // --------------------------
    // Part 1: Manual test vectors
    // --------------------------
    initial begin
        C = 0;

        $display("---- Half Subtractor ---");
        $display("A B | diffH borrowH");
        A=0; B=0; #10; $display("%b %b | %b %b", A,B,diff_half,borrow_half);
        A=0; B=1; #10; $display("%b %b | %b %b", A,B,diff_half,borrow_half);
        A=1; B=0; #10; $display("%b %b | %b %b", A,B,diff_half,borrow_half);
        A=1; B=1; #10; $display("%b %b | %b %b", A,B,diff_half,borrow_half);

        $display("\n---- Full Subtractor ----");
        $display("A B C | diffH borrowH | diffF borrowF");
        A=0; B=0; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=0; B=0; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=0; B=1; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=0; B=1; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=1; B=0; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=1; B=0; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=1; B=1; C=0; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
        A=1; B=1; C=1; #10; $display("%b %b %b | %b %b | %b %b", A,B,C,diff_half,borrow_half,diff_full,borrow_full);
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

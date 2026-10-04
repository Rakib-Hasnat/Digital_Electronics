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
        if (({borrow_half, diff_half, borrow_full, diff_full}) !== ({{1'b0,A} - B, {1'b0,A} - B - C})) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: A=%b B=%b C=%b got %b expected %b", $time, A, B, C, ({borrow_half, diff_half, borrow_full, diff_full}), ({{1'b0,A} - B, {1'b0,A} - B - C}));
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

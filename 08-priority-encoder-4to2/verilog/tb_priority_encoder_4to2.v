`timescale 1ns / 1ps

module priority_encoder_4to2_tb;

    // Inputs
    reg [3:0] D;

    // Outputs
    wire [1:0] Y;
    wire V;

    // Instantiate DUT
    priority_encoder_4to2 uut (
        .D(D),
        .Y(Y),
        .V(V)
    );

    // Dump waveform
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, priority_encoder_4to2_tb);
    end

    // --------------------------
    // Part 1: Manual test vectors
    // --------------------------
    initial begin
        $display("---- 4 to 2 Priority Encoder ----");
        $display("D    | Y  V");

        D = 4'b0000; #10; $display("%b | %b %b", D,Y,V);
        D = 4'b0001; #10; $display("%b | %b %b", D,Y,V);
        D = 4'b0010; #10; $display("%b | %b %b", D,Y,V);
        D = 4'b0100; #10; $display("%b | %b %b", D,Y,V);
        D = 4'b1000; #10; $display("%b | %b %b", D,Y,V);
        D = 4'b1111; #10; $display("%b | %b %b", D,Y,V);
    end

    // --------------------------
    // Part 2: Random inputs
    // --------------------------
    initial begin
        #80;  // wait for manual part

        repeat (20) begin
            D = $random % 16;
            #10;
        end
    end

    // Stop simulation
    initial begin
        #300 report_and_finish;
    end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(D) begin
        #1;
        checks = checks + 1;
        if (({Y, V}) !== ({(D[3] ? 2'd3 : D[2] ? 2'd2 : D[1] ? 2'd1 : 2'd0), |D})) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: D=%b got %b expected %b", $time, D, ({Y, V}), ({(D[3] ? 2'd3 : D[2] ? 2'd2 : D[1] ? 2'd1 : 2'd0), |D}));
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

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
        #300 $finish;
    end

endmodule

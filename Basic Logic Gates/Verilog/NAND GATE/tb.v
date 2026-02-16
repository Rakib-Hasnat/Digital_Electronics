`timescale 1ns / 1ps

module nand_gate_tb;

    // Inputs
    reg A, B;
    // Outputs
    wire X, Y, Z;

    // Instantiate your module
    nand_gate uut (        // module name is case-sensitive, use `nand_gate` not `NAND`
        .A(A),
        .B(B),
        .X(X),  
        .Y(Y),
        .Z(Z)
    );

    // Clock Signal
    reg clk;
    initial clk = 0;
    always #5 clk = ~clk;   // 10 ns period

    // Waveform dump
    initial begin
        $dumpfile("waveform.vcd");   
        $dumpvars(0, nand_gate_tb);  
    end

    // Generate random signals on clock
    always @(posedge clk) begin
        A = $random & 1;  // mask to 0 or 1
        B = $random & 1;
    end

    // Stop simulation after 100 ns
    initial begin
        #100 $finish;
    end

endmodule

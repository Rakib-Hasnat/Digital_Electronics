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
        #100 report_and_finish;
    end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(A or B) begin
        #1;
        checks = checks + 1;
        if (({X,Y,Z}) !== ({~A, A&B, A|B})) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: A=%b B=%b got %b expected %b", $time, A, B, ({X,Y,Z}), ({~A, A&B, A|B}));
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

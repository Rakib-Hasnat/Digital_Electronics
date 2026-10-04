
`timescale 1ns / 1ps

module mux_tb;
    reg [2:0] S;
    reg A;
    wire Y;
    integer i;

    mux uut(
        .S(S),
        .A(A),
        .Y(Y)
    );


    reg clk;
    initial clk =0;
    always #5 clk = ~clk;


    initial begin

        $dumpfile("waveform.vcd");
        $dumpvars(0, mux_tb);
        
        // Test for A = 0
        $display("\n\n\n=================================");
        $display("    Truth Table for A = 0 ");
        $display("=================================");
        $display(" S2   S1  S0 |  Input |  F  |");
        $display("------------------------------");
        
        A = 0;
        
        for (i = 0; i < 8; i++) begin
            S = i;
            #10; 
            $display("  %b   %b   %b  |  I%-2d   |  %b  |", S[2], S[1], S[0], i, Y);   
        end
        
        // Test for A = 1
        $display("\n\n\n=================================");
        $display("    Truth Table for A = 1 ");
        $display("=================================");
        $display(" S2   S1  S0 |  Input |  F  |");
        $display("------------------------------");
        
        A = 1;
        
        for (i = 0; i < 8; i++) begin
            S = i;
            #10; 
            $display("  %b   %b   %b  |  I%-2d   |  %b  |", S[2], S[1], S[0], i, Y);   
        end
    
        repeat (20) begin

            @(posedge clk);
                    
            S[2] = $random %2;
            S[1] = $random %2;
            S[0] = $random %2;
            A = $random %2;
            #1;
        
            $display("\n\n\n  %b  %b  %b | %b | %b", S[2], S[1], S[0], A, Y);
            
        end

        $display("\nSimulation Finished.");
        report_and_finish;
    end

    // ---------------------------------------------------------------
    // Self-check: compares the DUT against a reference model and
    // prints PASS/FAIL when the simulation ends.
    // ---------------------------------------------------------------
    integer errors = 0;
    integer checks = 0;

    always @(S or A) begin
        #1;
        checks = checks + 1;
        if ((Y) !== ((S==0 || S==1) ? 1'b1 : (S==3 || S==4) ? ~A : (S==7) ? A : 1'b0)) begin
            errors = errors + 1;
            $display("FAIL at t=%0t: S=%b A=%b got %b expected %b", $time, S, A, (Y), ((S==0 || S==1) ? 1'b1 : (S==3 || S==4) ? ~A : (S==7) ? A : 1'b0));
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


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
        $finish;
    end

endmodule
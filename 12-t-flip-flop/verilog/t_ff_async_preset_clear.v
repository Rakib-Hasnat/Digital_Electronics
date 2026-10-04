`timescale 1ns/1ps

// T flip-flop, positive-edge triggered, with ASYNCHRONOUS active-low
// preset (pr) and clear (cr): they act immediately, without waiting for the clock.
// Note: the output toggles when t == 0 (active-low T input).
module t_type (
    input  wire clk,
    input  wire t,
    input  wire pr,
    input  wire cr,
    output reg  q,
    output reg  q_bar
);

    always @(posedge clk or negedge pr or negedge cr) begin
        if (!cr) begin            
            q     <= 1'b0;
            q_bar <= 1'b1;
        end
        else if (!pr) begin
            q     <= 1'b1;
            q_bar <= 1'b0;
        end
        else if (t == 0) begin
            q     <= ~q;
            q_bar <= ~q_bar;
        end
    end

endmodule

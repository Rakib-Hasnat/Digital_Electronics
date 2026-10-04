`timescale 1ns/1ps

// T flip-flop, positive-edge triggered: Q toggles on every rising clock edge
// while t = 1 and holds while t = 0.
// ASYNCHRONOUS active-low preset (pr) and clear (cr): they act immediately,
// without waiting for the clock. Clear wins if both are low.
module t_ff_async (
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
        else if (t == 1'b1) begin    // toggle mode
            q     <= ~q;
            q_bar <= ~q_bar;
        end
    end

endmodule

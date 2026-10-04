`timescale 1ns/1ps

// T flip-flop, positive-edge triggered: Q toggles on every rising clock edge
// while t = 1 and holds while t = 0.
// SYNCHRONOUS active-low preset (pr) and clear (cr): they only take effect
// on a rising clock edge.
module t_ff_sync (
    input  wire clk,
    input  wire t,
    input  wire pr,
    input  wire cr,
    output reg  q,
    output reg  q_bar
);

    always @(posedge clk) begin
        if ((pr == 1'b0) && (cr == 1'b1)) begin
            q     <= 1'b1;
            q_bar <= 1'b0;
        end
        
	else if ((pr == 1'b1) && (cr == 1'b0)) begin
            q     <= 1'b0;
            q_bar <= 1'b1;
        end
        
	else if ((pr == 1'b1) && (cr == 1'b1)) begin
            if (t == 1'b1) begin     // toggle mode
                q     <= ~q;
                q_bar <= ~q_bar;
            end
        end

    end

endmodule

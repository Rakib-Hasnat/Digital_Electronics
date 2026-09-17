
module t_type (
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
            if (t == 0) begin
                q     <= ~q;
                q_bar <= ~q_bar;
            end
        end

    end

endmodule

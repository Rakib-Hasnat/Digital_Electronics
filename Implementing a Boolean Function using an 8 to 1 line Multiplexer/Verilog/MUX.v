
module mux (
      
    input wire [2:0] S ,
    input wire A,
    output reg Y
    );

    wire [7:0] I;

    assign I[0]= 1'b1;
    assign I[1]= 1'b1;
    assign I[2]= 1'b0;
    assign I[3]= ~A;
    assign I[4]= ~A;
    assign I[5]= 1'b0;
    assign I[6]= 1'b0;
    assign I[7]= A;

    always @(*) begin
        case (S)
            3'b000: Y = I[0];
            3'b001: Y = I[1];
            3'b010: Y = I[2];
            3'b011: Y = I[3];
            3'b100: Y = I[4];
            3'b101: Y = I[5];
            3'b110: Y = I[6]; 
            3'b111: Y = I[7];  
            default: Y = 1'b0;
        endcase

    end

endmodule
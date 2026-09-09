
module decoder_3to8 (
input wire [2:0] sel,
output wire [7:0] y);

wire A,B,C;

assign A = sel[0];  
assign B = sel[1];
assign C = sel[2];
 
assign y[0] = ((~C)&(~B)&(~A));
assign y[1] = ((~C)&(~B)&(A));
assign y[2] = ((~C)&(B)&(~A));
assign y[3] = ((~C)&(B)&(A));
assign y[4] = ((C)&(~B)&(~A));
assign y[5] = ((C)&(~B)&(A));
assign y[6] = ((C)&(B)&(~A));
assign y[7] = ((C)&(B)&(A));

endmodule

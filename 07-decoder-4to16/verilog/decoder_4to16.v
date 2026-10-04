`timescale 1ns/1ps

// 4-to-16 decoder built from two 3-to-8 decoders with an enable.
// sel[3] drives the enables: 0 selects the lower decoder (y[7:0]),
// 1 selects the upper decoder (y[15:8]).

module decoder_3to8 (
input wire [2:0] sel,
input wire en,
output wire [7:0] y);

wire A,B,C;

assign A = sel[0];
assign B = sel[1];
assign C = sel[2];
 
// Active-low enable (en = 0 turns the decoder on); outputs are active high
assign y[0] =  (~en & ((~C)&(~B)&(~A)) );
assign y[1] =  (~en & ((~C)&(~B)&(A)) );
assign y[2] =  (~en & ((~C)&(B)&(~A)) );
assign y[3] =  (~en & ((~C)&(B)&(A)) );
assign y[4] =  (~en & ((C)&(~B)&(~A)) );
assign y[5] =  (~en & ((C)&(~B)&(A)) );
assign y[6] =  (~en & ((C)&(B)&(~A)) );
assign y[7] =  (~en & ((C)&(B)&(A)) );

endmodule



module decoder_4to16 (
input wire [3:0] sel,
output wire [15:0] y
);

wire en;
assign en = sel[3];

decoder_3to8 one (.sel(sel[2:0]), .en(en), .y(y[7:0]));
decoder_3to8 two (.sel(sel[2:0]), .en(~en), .y(y[15:8]));

endmodule

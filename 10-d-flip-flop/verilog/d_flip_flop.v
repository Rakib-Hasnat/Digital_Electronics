
`timescale 1ns/1ps

module d_type (
input wire clk,
input wire d,
input pr,
input cr, 
output wire q,
output wire q_bar );

wire d_bar, clk_bar;
wire bc,cd,ef,gh, ij,kl;   

not #1 one (d_bar, d);
not #1 two (clk_bar, clk);

nand #1 three (bc, d, clk, q_bar);
nand #1 four (cd, d_bar, clk, q);

nand #1 five (ef, pr, bc, gh);
nand #1 six (gh, cd, cr, ef);

nand #1 seven (ij, ef, clk_bar);
nand #1 eight (kl, gh, clk_bar);

nand #1 nine (q, q_bar, ij);
nand #1 ten (q_bar, kl, q);

endmodule

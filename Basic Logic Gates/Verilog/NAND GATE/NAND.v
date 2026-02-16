module nand_gate(
    input A,
    input B,
    output X,Y,Z
);
wire u,v,w;

assign X = ~(A & A); //Not gate using NAND

assign u = ~(A & B); //AND gate using NAND
assign Y = ~(u & u);

assign v = ~(A & A); //OR gate using NAND
assign w = ~(B & B);
assign Z = ~(v & w);

endmodule
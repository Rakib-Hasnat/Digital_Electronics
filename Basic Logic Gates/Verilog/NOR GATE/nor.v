module nor_gate (
    input A,
    input B,
    output X,
    output Y,
    output Z
);
wire a,b,c;

assign X = ~(A | A); // NOT gate

assign a = ~(A | B); 
assign Y = ~(a | a); // AND gate

assign b = ~(A | A);
assign c =~(B | B);
assign Z = ~(b | c); // OR gate

endmodule
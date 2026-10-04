`timescale 1ns/1ps

// Universality of the NOR gate: NOT, OR and AND built only from 2-input NORs.
module nor_gate (
    input A,
    input B,
    output X,   // NOT A
    output Y,   // A OR B
    output Z    // A AND B
);
wire a,b,c;

assign X = ~(A | A); // NOT gate

assign a = ~(A | B);
assign Y = ~(a | a); // OR gate: NOR followed by a NOR-inverter

assign b = ~(A | A);
assign c =~(B | B);
assign Z = ~(b | c); // AND gate: NOR of the inverted inputs (De Morgan)

endmodule
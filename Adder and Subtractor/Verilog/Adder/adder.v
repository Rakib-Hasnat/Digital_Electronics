module adder (
input A,B,C,
output sum_half,carry_half,
output sum_full,carry_full
);

//Half Adder
assign sum_half = A ^ B; //XOR gate
assign carry_half = A & B; //AND gate

//Full Adder
assign sum_full = A ^ B ^ C; //XOR gate
assign carry_full = (A & B) | (B & C) | (C & A); //Carry out using AND and OR gates


endmodule
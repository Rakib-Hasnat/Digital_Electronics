`timescale 1ns/1ps
module tb_alu;

reg a;
reg b;
reg c;
reg [2:0] s;
wire o;

alu one (.a(a), .b(b), .c(c), .s(s), .o(o));

// Reference model, written independently of the DUT.
// Operations 101 and 110 are the sum and carry of a full adder,
// so they are checked against real addition.
function expected;
    input a, b, c;
    input [2:0] s;
    reg [1:0] total;
    begin
        total = a + b + c;
        case (s)
            3'b000: expected = ~(b & c);   // NAND
            3'b001: expected = ~(b | c);   // NOR
            3'b010: expected =  b & c;     // AND
            3'b011: expected =  b | c;     // OR
            3'b100: expected =  b ^ c;     // XOR
            3'b101: expected =  total[0];  // full-adder sum
            3'b110: expected =  total[1];  // full-adder carry
            3'b111: expected = ~a;         // NOT
        endcase
    end
endfunction

integer i, errors = 0;

initial begin
    $display("A B C | S2 S1 S0 | O");

    // All 64 combinations of the inputs and the select lines
    for (i = 0; i < 64; i = i + 1) begin
        {s, a, b, c} = i[5:0];
        #10;
        $display("%b %b %b |  %b  %b  %b | %b", a, b, c, s[2], s[1], s[0], o);
        if (o !== expected(a, b, c, s)) begin
            errors = errors + 1;
            $display("FAIL: a=%b b=%b c=%b s=%b got %b expected %b", a, b, c, s, o, expected(a, b, c, s));
        end
    end

    if (errors == 0) $display("PASS: 64 checks");
    else             $display("FAIL: %0d of 64 checks failed", errors);
    $finish;
end

endmodule

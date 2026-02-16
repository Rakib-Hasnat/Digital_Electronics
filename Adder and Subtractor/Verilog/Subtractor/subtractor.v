module subtractor (
    input A, B, C,              // Bin = Borrow in
    output diff_half, borrow_half,
    output diff_full, borrow_full
);

    // Half Subtractor
    assign diff_half = A ^ B;          // Difference
    assign borrow_half = ~A & B;       // Borrow

    // Full Subtractor
    assign diff_full = A ^ B ^ C;    // Difference
    assign borrow_full = (~A & B) | ((~A | B) & C); // Borrow out

endmodule

`timescale 1ns/1ps

// ============================================================
// T Flip-Flop — Negative edge triggered, toggle mode
// ============================================================
module tff (
    input  clk,
    input  reset,   // active HIGH async reset
    output reg q
);
    always @(negedge clk or posedge reset) begin
        if (reset) q <= 0;
        else       q <= ~q;
    end
endmodule


// ============================================================
// 4-bit Asynchronous Ripple Counter
// Each FF output drives the clock of the next — ripple effect
// Equivalent to 7493 IC configuration
// ============================================================
module async_counter_4bit (
    input  clk,
    input  reset,
    output wire [3:0] q
);
    // QA clocked by external clk
    // QB clocked by QA
    // QC clocked by QB
    // QD clocked by QC
    tff ff0 (.clk(clk  ), .reset(reset), .q(q[0]));
    tff ff1 (.clk(q[0] ), .reset(reset), .q(q[1]));
    tff ff2 (.clk(q[1] ), .reset(reset), .q(q[2]));
    tff ff3 (.clk(q[2] ), .reset(reset), .q(q[3]));

endmodule
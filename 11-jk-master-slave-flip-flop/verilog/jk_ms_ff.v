`timescale 1ns/1ps

// ============================================================
// JK Master-Slave Flip-Flop — Gate-Level Structural Model
// Equivalent to 7476 IC behavior
// Trigger: Falling edge of CLK
// PRE_bar / CLR_bar: Active LOW asynchronous override
// ============================================================

module jk_ms_ff (
    input  j,
    input  k,
    input  clk,
    input  pre_bar,   // Active LOW async preset  — forces Q=1
    input  clr_bar,   // Active LOW async clear   — forces Q=0
    output q,
    output q_bar
);

    wire clk_bar;
    wire m1, m2;
    wire s_s, r_s;
    wire s1, s2;

    // Clock inversion — slave is active when clk_bar=1
    not  #1 CLK_bar (clk_bar, clk);

    // Master steering gates — feedback from slave output (q, q_bar)
    nand #1 g3m (m1, j, q_bar, clk);
    nand #1 g4m (m2, k, q,     clk);

    // Master SR latch — pre/clr included to break x on startup
    nand #1 g1m (s_s, m1, r_s, pre_bar);
    nand #1 g2m (r_s, m2, s_s, clr_bar);

    // Slave steering gates — active only when clk_bar=1 (CLK=0)
    nand #1 g3s (s1, s_s, clk_bar);
    nand #1 g4s (s2, r_s, clk_bar);

    // Slave SR latch — true async pre/clr override at output
    nand #1 g1s (q,     s1, q_bar, pre_bar);
    nand #1 g2s (q_bar, s2, q,     clr_bar);

endmodule
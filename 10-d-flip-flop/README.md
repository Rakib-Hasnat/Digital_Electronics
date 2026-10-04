# 10 · D Flip-Flop (Gate Level)

A negative-edge-triggered master-slave D flip-flop built from ten NOT/NAND gate primitives, each with a 1 ns delay, rather than from a behavioral `always @(posedge clk)` block. Active-low preset (`pr`) and clear (`cr`) inputs act on the master latch.

## Files

| File | What it is |
|------|------------|
| [`verilog/d_flip_flop.v`](verilog/d_flip_flop.v) | Gate-level flip-flop: input steering, master NAND latch, slave NAND latch |
| [`verilog/tb_d_flip_flop.v`](verilog/tb_d_flip_flop.v) | Preset and clear, then 10 random D values; dumps `d_type_tb.vcd` |
| [`logisim/d_ff_using_gates.circ`](logisim/d_ff_using_gates.circ) | The same circuit in Logisim |
| [`report/`](report) | Lab report ([PDF](report/d_flip_flop.pdf)) |

## Behavior

While the clock is high, the master latch follows D. On the falling edge, the master closes and the slave copies its value to Q. Q settles about 3–4 ns after the edge because the signal passes through three gate delays.

## Run

```bash
bash ../run_all.sh 10
gtkwave ../build/d_flip_flop/d_type_tb.vcd
```

This testbench is a waveform demo, so `run_all.sh` treats it as a smoke test (it must compile and finish) rather than checking values.

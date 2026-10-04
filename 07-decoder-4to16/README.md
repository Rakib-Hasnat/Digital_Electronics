# 07 · 4-to-16 Line Decoder

A 4-to-16 decoder built hierarchically from two 3-to-8 decoders. The most significant input bit `sel[3]` acts as the enable: it turns on the lower decoder (outputs 0–7) when 0 and the upper decoder (outputs 8–15) when 1.

## Files

| File | What it is |
|------|------------|
| [`verilog/decoder_4to16.v`](verilog/decoder_4to16.v) | 3-to-8 decoder with an active-low enable, instantiated twice |
| [`verilog/tb_decoder_4to16.v`](verilog/tb_decoder_4to16.v) | Sweeps all 16 inputs, checks `y == 1 << sel` |
| [`report/`](report) | Lab report ([PDF](report/decoder_4to16.pdf)) |

## Structure

```
sel[2:0] ──┬──► 3-to-8 (en = sel[3])   ──► y[7:0]     active when sel[3] = 0
           └──► 3-to-8 (en = ~sel[3])  ──► y[15:8]    active when sel[3] = 1
```

## Run

```bash
bash ../run_all.sh 07 -v
```

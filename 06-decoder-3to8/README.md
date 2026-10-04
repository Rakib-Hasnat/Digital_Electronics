# 06 · 3-to-8 Line Decoder

A 3-bit input selects exactly one of eight outputs. Each output is one minterm of the inputs, for example `y[5] = C·B'·A`.

## Files

| File | What it is |
|------|------------|
| [`verilog/decoder_3to8.v`](verilog/decoder_3to8.v) | Decoder, one AND term per output |
| [`verilog/tb_decoder_3to8.v`](verilog/tb_decoder_3to8.v) | Sweeps all 8 inputs, checks `y == 1 << sel` |
| [`report/`](report) | Lab report ([PDF](report/decoder_3to8.pdf)) |

## Run

```bash
bash ../run_all.sh 06 -v
```

```
sel    y
000 00000001
001 00000010
010 00000100
011 00001000
100 00010000
101 00100000
110 01000000
111 10000000
```

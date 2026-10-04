# 09 · 1-to-8 Demultiplexer

Routes one data input `i` to one of eight outputs chosen by a 3-bit select; the other seven outputs stay 0.

## Files

| File | What it is |
|------|------------|
| [`verilog/demux_1to8.v`](verilog/demux_1to8.v) | Demultiplexer with a `case` statement |
| [`verilog/tb_demux_1to8_sweep.v`](verilog/tb_demux_1to8_sweep.v) | `i = 1`, every select value: the full truth table |
| [`verilog/tb_demux_1to8_random.v`](verilog/tb_demux_1to8_random.v) | 10 random `i`/`sel` pairs |
| [`report/`](report) | Lab report ([PDF](report/demux_1to8.pdf)) |

Both testbenches check `out == i << sel`.

## Run

```bash
bash ../run_all.sh 09 -v
```

```
sel       out
 000    00000001
 001    00000010
 010    00000100
 011    00001000
 100    00010000
 101    00100000
 110    01000000
 111    10000000
```

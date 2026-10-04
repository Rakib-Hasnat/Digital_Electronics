# 12 · T Flip-Flop with Synchronous and Asynchronous Preset/Clear

A positive-edge-triggered T flip-flop: on each rising clock edge, Q toggles when T = 1 and holds when T = 0. It comes in two versions that differ only in how the active-low preset (`pr`) and clear (`cr`) inputs act.

| Version | Module | Preset/clear takes effect |
|---------|--------|---------------------------|
| Synchronous | [`t_ff_sync`](verilog/t_ff_sync_preset_clear.v) | at the next rising clock edge (`always @(posedge clk)`) |
| Asynchronous | [`t_ff_async`](verilog/t_ff_async_preset_clear.v) | immediately (`always @(posedge clk or negedge pr or negedge cr)`) |

The testbench, [`verilog/tb_t_ff.v`](verilog/tb_t_ff.v), drives both versions with the same inputs and checks every row against hand-worked expected values. The gate-level circuit (a master-slave latch built from NAND gates) is in [`logisim/`](logisim), and the lab report is in [`report/`](report) ([PDF](report/t_flip_flop.pdf)).

## Characteristic table

| pr | cr | T | Q after the clock edge |
|----|----|---|------------------------|
| 0 | 1 | X | 1 (preset) |
| 1 | 0 | X | 0 (clear) |
| 1 | 1 | 0 | Q (hold) |
| 1 | 1 | 1 | Q' (toggle) |

## Run

```bash
bash ../run_all.sh 12 -v
```

```
  time | pr cr  t | Q sync  Q async | step
-------+----------+-----------------+------------------------
  6 ns |  1  0  0 |   0       0    | clear
 16 ns |  1  1  1 |   1       1    | toggle (t=1)
 26 ns |  1  1  1 |   0       0    | toggle (t=1)
 36 ns |  1  1  1 |   1       1    | toggle (t=1)
 46 ns |  1  1  0 |   1       1    | hold (t=0)
 51 ns |  1  0  0 |   1       0    | cr=0 between edges
 56 ns |  1  0  0 |   0       0    | cr=0 at the clock edge
 61 ns |  0  1  0 |   0       1    | pr=0 between edges
 66 ns |  0  1  0 |   1       1    | pr=0 at the clock edge
 76 ns |  1  1  1 |   0       0    | toggle (t=1)
 86 ns |  1  1  0 |   0       0    | hold (t=0)
PASS: 11 checks
```

The rows at 51 ns and 61 ns show the difference. When `cr` or `pr` goes low between clock edges, the asynchronous version reacts at once, while the synchronous version waits for the next rising edge (56 ns and 66 ns).

Waveforms are written to `build/t_flip_flop/t_ff.vcd` for GTKWave.

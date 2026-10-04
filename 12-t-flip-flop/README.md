# 12 · T Flip-Flop with Synchronous and Asynchronous Preset/Clear

Two versions of a positive-edge-triggered T flip-flop that differ only in how the active-low preset (`pr`) and clear (`cr`) inputs act.

| Version | File | Preset/clear takes effect |
|---------|------|---------------------------|
| Synchronous | [`verilog/t_ff_sync_preset_clear.v`](verilog/t_ff_sync_preset_clear.v) | at the next rising clock edge (`always @(posedge clk)`) |
| Asynchronous | [`verilog/t_ff_async_preset_clear.v`](verilog/t_ff_async_preset_clear.v) | immediately (`always @(posedge clk or negedge pr or negedge cr)`) |

Both versions use the same testbench, [`verilog/tb_t_ff.v`](verilog/tb_t_ff.v). The gate-level circuit is in [`logisim/`](logisim), and the lab report is in [`report/`](report) ([PDF](report/t_flip_flop.pdf)).

## Seeing the difference

```bash
bash ../run_all.sh 12 -v
```

When `pr` drops to 0 between clock edges, the asynchronous version sets Q to 1 at once, while the synchronous version waits for the next rising edge. The testbench prints a line every time a signal changes:

```
asynchronous                     synchronous
pr cr t | q q_bar                pr cr t | q q_bar
0  1  0 |  1   0  <- at once     0  1  0 |  x   x  <- pr low, Q not set yet
                                 0  1  0 |  1   0  <- set on the clock edge
```

> **Note:** in both files the flip-flop toggles when `t == 0`, so T is effectively active low. A standard T flip-flop toggles when T = 1.

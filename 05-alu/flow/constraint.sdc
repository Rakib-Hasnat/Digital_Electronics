# ORFS constraints: 10 ns clock with 2 ns input/output delays (used by config.mk).


create_clock -name clk -period 10
set_input_delay  2 -clock clk [all_inputs]
set_output_delay 2 -clock clk [all_outputs]

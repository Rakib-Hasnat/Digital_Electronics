# Constraints for the standalone STA run (sta.tcl): a 2 ns virtual clock
# with 0.2 ns input and output delays. Matches the timing report in report/alu.docx.
create_clock -name vclk -period 2
set_input_delay  0.2 -clock vclk [all_inputs]
set_output_delay 0.2 -clock vclk [all_outputs]

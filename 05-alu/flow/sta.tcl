# Static timing analysis of the synthesized ALU netlist (OpenSTA / OpenROAD).
# Run from this folder after syn.ys:  sta sta.tcl   (or: openroad sta.tcl)
read_liberty NangateOpenCellLibrary_typical.lib
read_verilog alu_netlist.v
link_design alu
read_sdc sta.sdc
report_checks -path_delay max -format full -fields {fanout cap slew}
exit

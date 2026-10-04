
read_liberty NangateOpenCellLibrary_typical.lib
read_verilog alu_net.v
link_design alu
read_sdc con.sdc
report_checks -path_delay max -format full -fields {fanout cap slew}
exit


# OpenROAD-flow-scripts (ORFS) design config for the ALU.
# From the ORFS flow/ directory:
#   make DESIGN_CONFIG=/path/to/Digital_Electronics/05-alu/flow/config.mk
# Paths are relative to this file, so the repo can live anywhere.
ALU_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

export PLATFORM        = sky130hd
export DESIGN_NAME     = alu
export DESIGN_NICKNAME = alu
export VERILOG_FILES   = $(ALU_DIR)/../verilog/alu.v
export SDC_FILE        = $(ALU_DIR)/constraint.sdc
export DIE_AREA        = 0 0 100 100
export CORE_AREA       = 10 10 90 90
export PLACE_DENSITY   = 0.6

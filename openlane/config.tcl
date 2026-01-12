# OpenLane Configuration for dac_top (OpenLane 1.x compatible)

set ::env(DESIGN_NAME) "dac_top"

# Verilog source files
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/../rtl/*.v]

# Clock configuration
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20.0"

# Die and core area (um)
set ::env(DIE_AREA) "0 0 100 100"
set ::env(FP_SIZING) "absolute"
set ::env(DESIGN_IS_CORE) 0

# Floorplan and placement
set ::env(FP_CORE_UTIL) 40
set ::env(PL_TARGET_DENSITY) 0.5
set ::env(GPL_CELL_PADDING) 2
set ::env(DPL_CELL_PADDING) 2

# Routing
set ::env(ROUTING_CORES) 4

# Disable CVC (Circuit Validity Checker) - optional
set ::env(RUN_CVC) 0

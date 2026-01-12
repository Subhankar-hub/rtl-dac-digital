#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -o build/tb_sd_measure.vvp tb/tb_sigma_delta_measure.v rtl/sigma_delta_dac.v
vvp build/tb_sd_measure.vvp

echo "Measurements written to build/sd_measurements.csv"
echo "Waveform written to build/wave_sd.vcd — open with: gtkwave build/wave_sd.vcd"

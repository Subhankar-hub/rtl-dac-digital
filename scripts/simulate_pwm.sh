#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
iverilog -g2012 -o build/tb_pwm_measure.vvp tb/tb_pwm_measure.v rtl/pwm_dac.v
vvp build/tb_pwm_measure.vvp

echo "Measurements written to build/pwm_measurements.csv"
echo "Waveform written to build/wave_pwm.vcd — open with: gtkwave build/wave_pwm.vcd"

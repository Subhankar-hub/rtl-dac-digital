# RTL DAC (digital only)

This repository focuses on RTL digital DAC designs (PWM and Sigma-Delta) and simulation-based performance measurement.

## Quick start
- Install Icarus Verilog and Yosys on your system and ensure `iverilog`, `vvp`, and `yosys` are on PATH.
- Make scripts executable: `chmod +x scripts/*.sh`
- Simulate PWM DAC: `./scripts/simulate_pwm.sh` → `build/pwm_measurements.csv`.
- Simulate Sigma-Delta DAC: `./scripts/simulate_sigma.sh` → `build/sd_measurements.csv`.
- Run Yosys RTL checks: `./scripts/synth_check.sh`.

## Performance modelling & experiments
Suggested experiments and metrics to learn and measure:

1. **PWM linearity & duty-cycle accuracy**
   - Measure measured_fraction from `pwm_measurements.csv` vs ideal `value/(2^W-1)`.
   - Plot error vs value and compute RMS error.
   - Estimate Effective Number Of Bits (ENOB) from measured SNR or RMS error.

2. **Sigma-Delta mean & noise-shaping**
   - Sigma-delta modulator output mean approximates input / full-scale.
   - Increase oversampling rate (faster clk) in tb and observe reduction in quantization noise in baseband.
   - Use frequency-domain analysis (export bitstream to file, do FFT in Python) to visualize noise shaping.

3. **Latency, throughput & clocking**
   - For PWM DAC, effective update rate is (system clock)/(2^WIDTH) if counter width is WIDTH.
   - For sigma-delta, throughput equals sampling frequency; oversampling trades off digital bandwidth.

4. **Synthesis checks**
   - Run Yosys to ensure design is synthesizable and view stat reports.

## Analysis scripts (optional)
- Use Python to load CSV results (`pandas`) and compute ENOB, SNR, error histograms, and plots.

## Next steps
- Add a register interface (APB/APB-lite or simple memory-mapped registers) to control DAC value from a CPU model.
- Add a testbench with randomized stimulus, or connect to a UVM environment for verification practice.
- Export sigma-delta bitstreams and perform FFT-based spectral analysis (Python + numpy).
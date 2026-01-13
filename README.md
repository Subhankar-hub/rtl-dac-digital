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

## RTL-to-GDS Flow (ASIC Tapeout)

This project supports full RTL-to-GDS using **OpenLane 2** with the **SkyWater 130nm PDK** (open-source).

### Prerequisites
- Python 3.8+
- Install OpenLane and PDK:

```bash
# Install OpenLane 2 and Volare (PDK manager)
pip install openlane volare

# Install the sky130 PDK
volare enable --pdk sky130 78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc
```

### Run RTL-to-GDS

```bash
make gds
```

### What happens during the flow

| Stage | Tool | Description |
|-------|------|-------------|
| **Synthesis** | Yosys | RTL → Gate-level netlist |
| **Floorplan** | OpenROAD | Define die area, place IOs, power grid |
| **Placement** | OpenROAD | Place standard cells |
| **CTS** | OpenROAD | Clock Tree Synthesis |
| **Routing** | OpenROAD | Connect all cells with metal wires |
| **Signoff** | Magic/Netgen | DRC, LVS, antenna checks |
| **GDS Export** | Magic | Final GDSII layout file |

### Output Files
After running, find outputs in `runs/<timestamp>/`:
```
runs/<run>/
├── final/
│   ├── gds/dac_top.gds      # Final layout (send to foundry)
│   ├── lef/dac_top.lef      # Abstract view for integration
│   └── nl/dac_top.v         # Gate-level netlist
├── reports/                  # Timing, area, power reports
└── logs/                     # Step-by-step logs
```

### View GDS Layout
```bash
# Using KLayout (install: sudo apt-get install klayout)
klayout runs/<run>/final/gds/dac_top.gds

# Or using Magic
magic -T sky130A runs/<run>/final/gds/dac_top.gds
```

### Configuration
Edit `openlane/config.json` to tune:
- `CLOCK_PERIOD`: Target clock period in ns (20.0 = 50MHz)
- `DIE_AREA`: Die dimensions in μm (`"0 0 100 100"` = 100×100μm)
- `FP_CORE_UTIL`: Core utilization % (lower = easier routing)
- `PL_TARGET_DENSITY`: Placement density

### Alternative: Tiny Tapeout
For actual fabrication, consider [Tiny Tapeout](https://tinytapeout.com/) which provides:
- Low-cost shuttle runs (~$150 for a small tile)
- Uses the same OpenLane flow
- Provides a template with IO ring already done

## Next steps
- Add a register interface (APB/APB-lite or simple memory-mapped registers) to control DAC value from a CPU model.
- Add a testbench with randomized stimulus, or connect to a UVM environment for verification practice.
- Export sigma-delta bitstreams and perform FFT-based spectral analysis (Python + numpy).
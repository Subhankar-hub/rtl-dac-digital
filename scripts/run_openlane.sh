#!/bin/bash
# RTL-to-GDS flow using OpenLane Docker
# Usage: ./scripts/run_openlane.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "RTL-to-GDS Flow using OpenLane + Docker"
echo "=========================================="
echo "Project: $PROJECT_DIR"
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed or not in PATH"
    echo "Install with: sudo apt-get install docker.io"
    exit 1
fi

# Create output directory
mkdir -p "$PROJECT_DIR/runs"

echo "Running OpenLane flow..."
docker run --rm \
    -v "$PROJECT_DIR:/openlane/designs/dac_top" \
    -v "$PROJECT_DIR/runs:/openlane/designs/dac_top/runs" \
    -e PDK=sky130A \
    efabless/openlane:latest \
    bash -c "flow.tcl -design dac_top -config_file designs/dac_top/openlane/config.tcl"

echo ""
echo "=========================================="
echo "GDS flow complete!"
echo "Output files in: runs/<run_name>/results/final/"
echo "  - GDS:     results/final/gds/*.gds"
echo "  - LEF:     results/final/lef/*.lef"
echo "  - Netlist: results/final/verilog/gl/*.v"
echo "  - Reports: reports/"
echo "=========================================="

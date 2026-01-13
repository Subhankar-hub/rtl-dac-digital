#!/bin/bash
# RTL-to-GDS flow using OpenLane 2 (from The-OpenROAD-Project/OpenLane)
# Usage: ./scripts/run_openlane.sh
#
# Prerequisites:
#   pip install openlane volare
#   volare enable --pdk sky130 78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "RTL-to-GDS Flow using OpenLane 2"
echo "=========================================="
echo "Project: $PROJECT_DIR"
echo ""

# Check if openlane is installed
if ! command -v openlane &> /dev/null; then
    echo "ERROR: OpenLane 2 is not installed"
    echo ""
    echo "Install with:"
    echo "  pip install openlane volare"
    echo "  volare enable --pdk sky130 78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc"
    exit 1
fi

# Check if PDK is available
if [ ! -d "$HOME/.volare/sky130A" ] && [ -z "$PDK_ROOT" ]; then
    echo "WARNING: sky130A PDK not found in ~/.volare/sky130A"
    echo ""
    echo "Install PDK with:"
    echo "  volare enable --pdk sky130 78b7bc32ddb4b6f14f76883c2e2dc5b5de9d1cbc"
    echo ""
    echo "Attempting to continue anyway..."
fi

# Create output directory
mkdir -p "$PROJECT_DIR/runs"

cd "$PROJECT_DIR"

echo "Running OpenLane flow..."
openlane openlane/config.json --pdk sky130A

echo ""
echo "=========================================="
echo "GDS flow complete!"
echo "Output files in: runs/<run_name>/final/"
echo "  - GDS:     final/gds/*.gds"
echo "  - LEF:     final/lef/*.lef"
echo "  - Netlist: final/nl/*.v"
echo "  - Reports: *.rpt"
echo "=========================================="

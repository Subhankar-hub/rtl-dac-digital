#!/bin/bash
# RTL-to-GDS flow using OpenLane 1.x Docker (classic flow)
# Usage: ./scripts/run_openlane1.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "RTL-to-GDS Flow using OpenLane 1.x"
echo "=========================================="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed"
    exit 1
fi

# Pull OpenLane image if not present
echo "Pulling OpenLane Docker image (this may take a while first time)..."
docker pull efabless/openlane:latest

# Run the flow
echo "Starting OpenLane flow..."
docker run --rm \
    -v "$PROJECT_DIR:/openlane/designs/dac_top" \
    -v "$PROJECT_DIR/runs:/openlane/designs/dac_top/runs" \
    -e PDK=sky130A \
    efabless/openlane:latest \
    flow.tcl -design dac_top -config_file designs/dac_top/openlane/config.tcl

echo ""
echo "Flow complete! Check runs/ directory for output."

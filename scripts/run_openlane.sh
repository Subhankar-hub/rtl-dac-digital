#!/bin/bash
# RTL-to-GDS flow using OpenLane2 Docker
# Usage: ./scripts/run_openlane.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "RTL-to-GDS Flow using OpenLane2 + Docker"
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
mkdir -p "$PROJECT_DIR/gds_output"

# Option 1: OpenLane2 (newer, recommended)
echo "Running OpenLane2 flow..."
docker run --rm \
    -v "$PROJECT_DIR:/work" \
    -w /work \
    efabless/openlane2:latest \
    openlane openlane/config.json

echo ""
echo "=========================================="
echo "GDS flow complete!"
echo "Output files in: runs/<run_name>/final/"
echo "  - GDS:     final/gds/*.gds"
echo "  - LEF:     final/lef/*.lef"
echo "  - Netlist: final/nl/*.v"
echo "  - Reports: reports/"
echo "=========================================="

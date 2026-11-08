#!/usr/bin/env bash
# run_one.sh - compile and run the testbench in one directory.
#
# Usage:
#   ./scripts/run_one.sh examples/00-setup/mux2
#   ./scripts/run_one.sh exercises/04-combinational/ex1-priority-encoder
#
# All .v (and .sv) files in the directory are compiled together.
# The simulation runs inside that directory, so the waveform file
# (tb_*.vcd) is written there. Open it with: gtkwave <dir>/tb_*.vcd

set -eu

if [ $# -ne 1 ] || [ ! -d "$1" ]; then
  echo "Usage: $0 <directory with a tb_*.v file>"
  exit 2
fi

dir="$(cd "$1" && pwd)"
gen="-g2001"
if ls "$dir"/*.sv >/dev/null 2>&1; then
  gen="-g2012"
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/build"
out="$ROOT/build/run_one.vvp"

# shellcheck disable=SC2046
iverilog "$gen" -Wall -o "$out" $(ls "$dir"/*.v "$dir"/*.sv 2>/dev/null)
cd "$dir"
vvp -n "$out"

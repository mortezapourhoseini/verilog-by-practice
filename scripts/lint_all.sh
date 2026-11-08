#!/usr/bin/env bash
# lint_all.sh - optional checks with Verilator (lint) and Yosys (synthesis).
#
# This script checks only design files (not tb_*.v). It skips any example
# directory that contains a file named SIM_ONLY, because that code is
# simulation-only on purpose.
#
# Verilator warnings are printed but do not fail the script.
# A Verilator or Yosys error (code that cannot be read or synthesized) does.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
errors=0

have_verilator=0
have_yosys=0
command -v verilator >/dev/null 2>&1 && have_verilator=1
command -v yosys >/dev/null 2>&1 && have_yosys=1

if [ $have_verilator -eq 0 ] && [ $have_yosys -eq 0 ]; then
  echo "Neither verilator nor yosys is installed. Nothing to do."
  exit 0
fi

check_dir() {
  local dir="$1"
  local files
  files=$(ls "$dir"/*.v 2>/dev/null | grep -v '/tb_' || true)
  [ -z "$files" ] && return
  [ -f "$dir/SIM_ONLY" ] && { echo "SKIP  ${dir#"$ROOT"/} (SIM_ONLY)"; return; }

  if [ $have_verilator -eq 1 ]; then
    # shellcheck disable=SC2086
    if ! verilator --lint-only -Wall -Wno-fatal -Wno-DECLFILENAME -Wno-MULTITOP $files; then
      echo "ERROR verilator: ${dir#"$ROOT"/}"
      errors=$((errors + 1))
    fi
  fi

  if [ $have_yosys -eq 1 ]; then
    # shellcheck disable=SC2086
    if yosys -p "read_verilog $files; hierarchy -auto-top; synth; stat" > /tmp/yosys.log 2>&1; then
      echo "SYNTH ${dir#"$ROOT"/}: $(grep 'Number of cells' /tmp/yosys.log | tail -n 1 | tr -s ' ')"
    else
      echo "ERROR yosys: ${dir#"$ROOT"/}"
      cat /tmp/yosys.log
      errors=$((errors + 1))
    fi
  fi
}

while IFS= read -r tb; do
  check_dir "$(dirname "$tb")"
done < <(find "$ROOT/examples" -name 'tb_*.v' | sort)

while IFS= read -r sdir; do
  check_dir "$sdir"
done < <(find "$ROOT/solutions" -mindepth 2 -maxdepth 2 -type d | sort)

echo
echo "Lint/synthesis errors: $errors"
[ $errors -eq 0 ]

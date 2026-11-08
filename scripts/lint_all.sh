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

# check NAME FILE...  (design files only, no testbench)
check() {
  local name="$1"
  shift
  local files="$*"
  [ -z "$files" ] && return

  if [ $have_verilator -eq 1 ]; then
    # shellcheck disable=SC2086
    if ! verilator --lint-only -Wall -Wno-fatal -Wno-DECLFILENAME -Wno-MULTITOP $files; then
      echo "ERROR verilator: $name"
      errors=$((errors + 1))
    fi
  fi

  if [ $have_yosys -eq 1 ]; then
    # No -top: every module in the files is synthesized, so a buggy module
    # next to a good one (as in the pitfalls examples) is checked too.
    if yosys -p "read_verilog $files; synth; stat" > /tmp/yosys.log 2>&1; then
      echo "SYNTH $name: $(awk '/^=== /{m=$2} /Number of cells:/{if (!(m in seen)) printf "%s=%s ", m, $NF; seen[m]=1}' /tmp/yosys.log)"
      grep 'Latch inferred' /tmp/yosys.log | grep -v '^No latch' | sed 's/ from process.*//; s/^/      /'
    else
      echo "ERROR yosys: $name"
      tail -n 20 /tmp/yosys.log
      errors=$((errors + 1))
    fi
  fi
}

design_files() {   # all .v files in a directory except testbenches
  ls "$1"/*.v 2>/dev/null | grep -v '/tb_' | tr '\n' ' '
}

while IFS= read -r tb; do
  dir="$(dirname "$tb")"
  name="${dir#"$ROOT"/}"
  if [ -f "$dir/SIM_ONLY" ]; then echo "SKIP  $name (SIM_ONLY)"; continue; fi
  check "$name" $(design_files "$dir")
done < <(find "$ROOT/examples" -name 'tb_*.v' | sort)

# Solutions: the solution files plus helper files from exercises/
# (but not the stub that has the same name as a solution file).
while IFS= read -r sdir; do
  rel="${sdir#"$ROOT"/solutions/}"
  edir="$ROOT/exercises/$rel"
  [ -f "$edir/SIM_ONLY" ] && { echo "SKIP  solutions/$rel (SIM_ONLY)"; continue; }
  files="$(design_files "$sdir")"
  for f in $(design_files "$edir"); do
    [ -e "$sdir/$(basename "$f")" ] || files="$files $f"
  done
  # shellcheck disable=SC2086
  check "solutions/$rel" $files
done < <(find "$ROOT/solutions" -mindepth 2 -maxdepth 2 -type d | sort)

echo
echo "Lint/synthesis errors: $errors"
[ $errors -eq 0 ]

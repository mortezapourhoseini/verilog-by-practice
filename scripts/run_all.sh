#!/usr/bin/env bash
# run_all.sh - compile and run every example and every exercise solution.
#
# A test passes only when all three are true:
#   1. iverilog compiles it without errors,
#   2. vvp exits with status 0,
#   3. the output has a line that starts with "PASS" and no line that starts with "FAIL".
#
# Usage:
#   ./scripts/run_all.sh            run everything
#   ./scripts/run_all.sh examples   run only the examples
#   ./scripts/run_all.sh solutions  run only the exercise solutions
#   ./scripts/run_all.sh stubs      check that every unsolved exercise stub FAILS
#                                   (this proves the testbenches catch wrong code)
#
# Set VERBOSE=1 to print the full simulation output of every test.
# The script exits with status 1 if any test fails.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
WHAT="${1:-all}"
TIMEOUT="${TIMEOUT:-60}"
VERBOSE="${VERBOSE:-0}"

mkdir -p "$BUILD"
pass=0
fail=0
failed_list=""

if ! command -v iverilog >/dev/null 2>&1; then
  echo "ERROR: iverilog not found. See docs/00-setup.md"
  exit 1
fi

# run_test NAME WORKDIR FILE...
#   NAME     short name shown in the report
#   WORKDIR  directory where vvp runs (for $readmemh and $fopen paths)
#   FILE...  Verilog sources to compile
run_test() {
  local name="$1"
  local workdir="$2"
  shift 2

  # Use SystemVerilog mode only if a .sv file is part of the test.
  local gen="-g2001"
  local f
  for f in "$@"; do
    case "$f" in
      *.sv) gen="-g2012" ;;
    esac
  done

  local base="$BUILD/$(echo "$name" | tr '/' '_')"
  local log="$base.log"

  if ! iverilog "$gen" -Wall -o "$base.vvp" "$@" > "$log" 2>&1; then
    echo "FAIL  $name  (compile error)"
    sed 's/^/      /' "$log"
    fail=$((fail + 1))
    failed_list="$failed_list $name"
    return
  fi

  local status=0
  (cd "$workdir" && timeout "$TIMEOUT" vvp -n "$base.vvp" < /dev/null) >> "$log" 2>&1 || status=$?

  if [ "$status" -eq 0 ] && grep -q '^PASS' "$log" && ! grep -q '^FAIL' "$log"; then
    echo "PASS  $name"
    [ "$VERBOSE" = "1" ] && sed 's/^/      | /' "$log"
    pass=$((pass + 1))
  else
    echo "FAIL  $name  (exit status $status)"
    sed 's/^/      /' "$log"
    fail=$((fail + 1))
    failed_list="$failed_list $name"
  fi
}

# Every directory under examples/ that holds a testbench (tb_*.v or tb_*.sv)
# is one test. All .v and .sv files in that directory are compiled together.
run_examples() {
  local tb dir
  while IFS= read -r tb; do
    dir="$(dirname "$tb")"
    # shellcheck disable=SC2046
    run_test "${dir#"$ROOT"/}" "$dir" $(ls "$dir"/*.v "$dir"/*.sv 2>/dev/null)
  done < <(find "$ROOT/examples" -name 'tb_*.v' -o -name 'tb_*.sv' | sort)
}

# Every directory under solutions/ is one test. We compile the solution files
# together with the files of the matching exercises/ directory (testbench and
# helper modules). A file in exercises/ that has the same name as a solution
# file is the student stub, so it is NOT compiled: the solution replaces it.
run_solutions() {
  local sdir rel edir f files
  while IFS= read -r sdir; do
    rel="${sdir#"$ROOT"/solutions/}"
    edir="$ROOT/exercises/$rel"
    if [ ! -d "$edir" ]; then
      echo "FAIL  solutions/$rel  (no matching exercises/$rel directory)"
      fail=$((fail + 1))
      failed_list="$failed_list solutions/$rel"
      continue
    fi
    files="$(ls "$sdir"/*.v "$sdir"/*.sv 2>/dev/null)"
    for f in $(ls "$edir"/*.v "$edir"/*.sv 2>/dev/null); do
      [ -e "$sdir/$(basename "$f")" ] || files="$files $f"
    done
    # shellcheck disable=SC2086
    run_test "solutions/$rel" "$edir" $files
  done < <(find "$ROOT/solutions" -mindepth 2 -maxdepth 2 -type d | sort)
}

# Every exercise stub must compile, and its testbench must report FAIL.
# A testbench that passes on the empty stub does not test anything.
run_stubs() {
  local edir rel base log status
  while IFS= read -r edir; do
    rel="${edir#"$ROOT"/}"
    base="$BUILD/stub_$(echo "$rel" | tr '/' '_')"
    log="$base.log"
    # shellcheck disable=SC2046
    if ! iverilog -g2001 -Wall -o "$base.vvp" $(ls "$edir"/*.v) > "$log" 2>&1; then
      echo "FAIL  $rel  (stub does not compile)"
      sed 's/^/      /' "$log"
      fail=$((fail + 1)); failed_list="$failed_list $rel"
      continue
    fi
    status=0
    (cd "$edir" && timeout "$TIMEOUT" vvp -n "$base.vvp" < /dev/null) >> "$log" 2>&1 || status=$?
    if [ "$status" -ne 0 ] && grep -q '^FAIL' "$log"; then
      echo "PASS  $rel  (stub fails as expected)"
      pass=$((pass + 1))
    else
      echo "FAIL  $rel  (stub should fail, but it did not)"
      sed 's/^/      /' "$log"
      fail=$((fail + 1)); failed_list="$failed_list $rel"
    fi
  done < <(find "$ROOT/exercises" -mindepth 2 -maxdepth 2 -type d | sort)
}

case "$WHAT" in
  all)       run_examples; run_solutions ;;
  examples)  run_examples ;;
  solutions) run_solutions ;;
  stubs)     run_stubs ;;
  *) echo "Usage: $0 [all|examples|solutions|stubs]"; exit 2 ;;
esac

echo
echo "Summary: $pass passed, $fail failed"
if [ "$fail" -ne 0 ]; then
  echo "Failed:$failed_list"
  exit 1
fi
exit 0

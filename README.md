# Verilog by Practice

[![ci](https://github.com/mortezapourhoseini/verilog-by-practice/actions/workflows/ci.yml/badge.svg)](https://github.com/mortezapourhoseini/verilog-by-practice/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A practical, project-based Verilog refresher.
Every concept comes with a small runnable example and a self-checking testbench.

## Who is this for?

You know binary numbers, logic gates and basic digital design.
You learned some Verilog once, but you forgot it, or you never practised it.
This repository brings you back to a working level quickly, by doing.

It is **not** a course for absolute beginners in digital logic.

## What you get

- 15 short chapters. Each one takes about 30 minutes to read.
- Runnable examples in `examples/`. Every example prints `PASS` or `FAIL`.
- Exercises with ready testbenches in `exercises/`, and solutions in `solutions/`.
- For every common mistake: the wrong code, why it is wrong, and the fix.
- A one-page [cheat sheet](docs/cheat-sheet.md) and a [debugging checklist](docs/14-debugging-checklist.md).
- CI that compiles and runs every example and every solution on each push.

The main text uses **Verilog-2001** only. A short
[appendix](docs/appendix-systemverilog.md) shows the most useful SystemVerilog
features for testbenches.

## Quick start

### 1. Install the tools

Linux (Debian, Ubuntu, Linux Mint):

```bash
sudo apt update
sudo apt install iverilog gtkwave
iverilog -V 2>&1 | head -n 1      # check: Icarus Verilog version 11 or 12
```

Windows: use WSL (then the same commands as Linux) or the native installer.
See [docs/00-setup.md](docs/00-setup.md) for details.

Prefer an IDE? [VeriNest](https://github.com/mortezapourhoseini/verinest) is a
small offline learning IDE with explained errors and a built-in waveform viewer.
The setup chapter shows how to install it in a few lines.

Optional extras: `sudo apt install verilator yosys` (lint and synthesis checks).

### 2. Check your setup (under five minutes)

```bash
git clone https://github.com/mortezapourhoseini/verilog-by-practice.git
cd verilog-by-practice/examples/00-setup/mux2
iverilog -g2001 -Wall -o mux2.vvp mux2.v tb_mux2.v
vvp mux2.vvp                      # should print: PASS: tb_mux2
gtkwave tb_mux2.vcd &             # look at the waveform
```

### 3. Run everything

From the repository root:

```bash
make                                         # all examples and solutions
make run DIR=examples/05-sequential-logic/counter
make wave DIR=examples/05-sequential-logic/counter
make clean
```

## How to use this repository

1. Read a chapter in `docs/`.
2. Run its examples. Change something, run again, and look at the waveform.
3. Solve its exercises. Each exercise folder has a ready testbench:
   `make run DIR=exercises/<chapter>/<exercise>`.
4. Compare with `solutions/` only after you see `PASS` (or after a real try).

Read the chapters in order. Later chapters use ideas from earlier ones.

## Chapters

| # | Chapter | Main topics |
|---|---|---|
| 00 | [Setup](docs/00-setup.md) | Install, check your setup, testbench pattern |
| 01 | [Modules and ports](docs/01-modules-and-ports.md) | `module`, ports, instances, hierarchy basics |
| 02 | [Data types, vectors and literals](docs/02-data-types-vectors-literals.md) | `wire`, `reg`, `integer`, vectors, `4'b1010`, x and z |
| 03 | [Operators](docs/03-operators.md) | Bitwise, logical, reduction, shift, concatenation, signed, width rules |
| 04 | [Combinational logic](docs/04-combinational-logic.md) | `assign`, `always @(*)`, `if`, `case`, accidental latches |
| 05 | [Sequential logic](docs/05-sequential-logic.md) | Clock, reset, blocking vs non-blocking, counters, shift registers |
| 06 | [Finite state machines](docs/06-fsm.md) | Moore, Mealy, coding styles |
| 07 | [Parameters, generate, functions, hierarchy](docs/07-parameters-generate-hierarchy.md) | `parameter`, `generate`, `function`, `task` |
| 08 | [Memories and arrays](docs/08-memories.md) | ROM, RAM, register file, `$readmemh` |
| 09 | [Testbenches](docs/09-testbenches.md) | Clocks, stimulus, self-checking, tasks, file I/O, randomisation |
| 10 | [Synthesizable vs simulation-only code](docs/10-synthesizable-vs-simulation.md) | What becomes hardware and what does not |
| 11 | [Race conditions and timing pitfalls](docs/11-races-and-timing.md) | Event order, races, delays, sensitivity lists |
| 12 | [Arithmetic blocks](docs/12-arithmetic-blocks.md) | Adders, multipliers, MAC, fixed point, pipelining |
| 13 | [Towards FPGA design](docs/13-towards-fpga.md) | LUT model, pipelining for speed, code to hardware |
| 14 | [Debugging checklist](docs/14-debugging-checklist.md) | A step-by-step list for when things go wrong |
| - | [Cheat sheet](docs/cheat-sheet.md) | One page of syntax |
| - | [Appendix: SystemVerilog for testbenches](docs/appendix-systemverilog.md) | `logic`, `always_ff`, assertions, classes (short) |

## Repository layout

```text
docs/                    one chapter per file
examples/<chapter>/<ex>/ design (*.v), testbench (tb_*.v), README.md
exercises/<chapter>/<ex>/ README.md (problem), stub *.v, testbench tb_*.v
solutions/<chapter>/<ex>/ solution *.v (uses the testbench from exercises/)
scripts/run_all.sh       compile and run every example and solution
scripts/run_one.sh       compile and run one directory
scripts/lint_all.sh      optional Verilator and Yosys checks
.github/workflows/ci.yml the same tests on every push
```

## Conventions

- Verilog-2001, `timescale 1ns/1ps` in every file.
- Lower-case `snake_case` names. Active-low signals end in `_n` (for example `rst_n`).
- Ports are connected **by name**, never by position.
- Every testbench prints exactly one result line: `PASS: <name>` or `FAIL: <name> (...)`,
  and exits with a non-zero status on failure.
- Two-space indentation.

## Free resources

- [Icarus Verilog documentation](https://steveicarus.github.io/iverilog/)
- [GTKWave documentation](https://gtkwave.github.io/gtkwave/)
- [HDLBits](https://hdlbits.01xz.net/): many small online Verilog problems
- [Verilator](https://verilator.org/) and [Yosys](https://yosyshq.net/yosys/)

## Contributing

Fixes, clearer explanations and new exercises are welcome.
See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE).

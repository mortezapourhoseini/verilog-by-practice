# Contributing

Thank you for helping. Good contributions are:

- fixing a bug in an example or a testbench,
- making an explanation shorter or clearer,
- adding an exercise (with a testbench and a solution),
- reporting something confusing (open an issue).

## Writing style

Many readers are not native English speakers. Please:

- use plain English and short sentences,
- explain **why**, not only **what**,
- show the wrong code and the fix for each common mistake,
- write your own text and code. Do not copy from books, courses or other repositories.

## Code style

- Verilog-2001 in the main chapters. SystemVerilog only in the appendix (`.sv` files).
- `` `timescale 1ns/1ps `` at the top of every file.
- `snake_case` names, two-space indentation, one port per line.
- Connect ports by name: `.clk(clk)`.
- Synthesizable designs: `always @(*)` for combinational logic,
  `always @(posedge clk)` with non-blocking `<=` for registers.

## Testbench rules

Every testbench must:

1. be called `tb_<module>.v` and be the only testbench in its folder,
2. dump a waveform to `tb_<module>.vcd`,
3. check outputs with `!==` and count errors,
4. print exactly one result line, `PASS: tb_<module>` or `FAIL: tb_<module> (...)`,
5. end with `$finish` on success and `$fatal(1, ...)` on failure,
6. finish within a few seconds.

## Adding an example

1. Create `examples/<chapter>/<name>/` with the design, `tb_<name>.v` and a short `README.md`.
2. If the design is simulation-only on purpose, add an empty file called `SIM_ONLY`
   so the optional synthesis check skips it.
3. Run `make` and check that everything passes.

## Adding an exercise

1. Create `exercises/<chapter>/exN-<name>/` with `README.md`, a stub `.v` file
   (it must compile, but the testbench must fail) and `tb_<name>.v`.
2. Create `solutions/<chapter>/exN-<name>/` with the solution `.v` file(s).
   The scripts compile the solution with the testbench from `exercises/`.
3. Run `make solutions`.

## Before you open a pull request

```bash
make            # all tests must pass
make lint       # optional, needs verilator and yosys
```

The CI runs the same tests on every push and pull request.

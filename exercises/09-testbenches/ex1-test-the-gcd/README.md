# Exercise 09.1: write the testbench for a GCD unit

This time the design is given and **the testbench is your job**.

`gcd.v` computes the greatest common divisor of two 16-bit numbers. It needs
a variable number of clock cycles, so it uses a small handshake:

```text
clk     _/~\_/~\_/~\_/~\_ ... _/~\_/~\_/~\_
start   _/~~~\_____________________________
busy    _____/~~~~~~~~~~~ ... ~~~~~\_______
done    ______________________/~~~\________
result  ----------------------< valid ......
```

## Task

Complete `tb_gcd.v`. Your testbench must:

1. generate a clock and apply a reset,
2. have a task `run_gcd(x, y)` that starts the unit, **waits for `done`**
   and compares `result` with a reference model,
3. include a reference model: a Verilog **function** `ref_gcd` that uses the
   modulo form of Euclid's algorithm (`while (b != 0) {t = b; b = a % b; a = t;}`),
4. test directed cases: `gcd(0,0)`, `gcd(0,7)`, `gcd(7,0)`, `gcd(12,8)`,
   `gcd(17,13)` (prime numbers), `gcd(1024,48)` and equal inputs,
5. test at least 300 random pairs (keep them below 1024, so the test stays fast),
6. have a **watchdog**: if `done` never comes, stop with `FAIL`,
7. print exactly one `PASS: tb_gcd` or `FAIL: tb_gcd ...` line and call
   `$fatal(1, ...)` on failure.

Use `examples/09-testbenches/tb-toolkit/tb_accumulator.v` as a template.

## Check your testbench

A testbench that always says PASS is worthless. After it passes, break the
DUT on purpose, for example change `a >= b` to `a > b` in `gcd.v`, and make
sure your testbench reports `FAIL`. Then undo the change.

## Run

```bash
make run DIR=exercises/09-testbenches/ex1-test-the-gcd
```

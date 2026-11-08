# Example: 4-bit ripple-carry adder

Four `full_adder` instances connected in a chain.

| File | What it is |
|---|---|
| `full_adder.v` | One-bit full adder |
| `ripple_adder4.v` | Four instances, connected through the carry vector `c[4:0]` |
| `tb_ripple_adder4.v` | Tests all 512 input combinations |

## Run

```bash
make run DIR=examples/01-modules-and-ports/ripple-adder4
```

## What to look at

- How bits of a vector (`a[0]`, `c[1]`) are connected to 1-bit ports.
- `` `default_nettype none `` at the top of `ripple_adder4.v`.
  Try this: in instance `fa0`, change `.cout(c[1])` to `.cout(c1)` (a typo).
  Compile again. You get an error, because `c1` was never declared.
  Now also remove the `` `default_nettype none `` line and compile again.
  This time there is no error, only a warning (`implicit definition of wire 'c1'`):
  Verilog creates a new 1-bit wire `c1`, and `c[1]` is never driven. The testbench fails, and you must hunt for the bug.
- In chapter 07 the four instance lines become one `generate` loop.

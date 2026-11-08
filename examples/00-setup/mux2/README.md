# Example: 2-to-1 multiplexer (check your setup)

This is the "check your setup" example from [chapter 00](../../../docs/00-setup.md).
If it prints `PASS: tb_mux2`, your tools work.

## Files

| File | What it is |
|---|---|
| `mux2.v` | The design: `y = sel ? b : a` |
| `tb_mux2.v` | Self-checking testbench. It tries all 8 input combinations. |

## Run

From the repository root:

```bash
make run DIR=examples/00-setup/mux2
```

Or by hand, inside this folder:

```bash
iverilog -g2001 -Wall -o mux2.vvp mux2.v tb_mux2.v
vvp mux2.vvp
gtkwave tb_mux2.vcd
```

## Expected output

```text
VCD info: dumpfile tb_mux2.vcd opened for output.
PASS: tb_mux2
tb_mux2.v:59: $finish called at 80000 (1ps)
```

## Expected waveform

```text
time (ns)  0    10   20   30   40   50   60   70   80
sel        0    0    0    0    1    1    1    1
b          0    0    1    1    0    0    1    1
a          0    1    0    1    0    1    0    1
y          0    1    0    1    0    0    1    1
```

## Try this

1. Change `assign y = sel ? b : a;` to `assign y = sel ? a : b;`.
   Run again. You should see `ERROR` lines and `FAIL: tb_mux2`.
2. Put the line back and check that it passes again.

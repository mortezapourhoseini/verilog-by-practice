# Example: accidental latch and incomplete sensitivity list

Two classic bugs, each next to its fix.

| Module | Bug or fix |
|---|---|
| `latch_bad` | `if (en) q = d;` with no `else`: q keeps its value, so a latch is built |
| `latch_fixed` | adds `else q = 1'b0;` |
| `mux_bad_sens` | `always @(a or b)`: forgets `sel` |
| `mux_good_sens` | `always @(*)` |

The testbench passes when the bugs behave as described in
[chapter 04](../../../docs/04-combinational-logic.md).

## Run

```bash
make run DIR=examples/04-combinational-logic/pitfalls
```

## What the waveform shows

```text
time (ns)   0    10   20
en          1    0    0
d           1    1    0
q_bad       1    1    1     <- holds 1 after en falls: a latch
q_fixed     1    0    0
```

```text
time (ns)  30   40   50
sel        0    1    1
a          0    0    1
y_bad      0    0    1     <- ignores the change of sel at 40
y_good     0    1    1
```

Run `make lint` (needs Yosys) and look for `Latch inferred for signal`
next to this example.

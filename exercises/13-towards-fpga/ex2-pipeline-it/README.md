# Exercise 13.2: pipeline a dot product

`dot4.v` computes a 4-element dot product of unsigned bytes:

```text
y = a[0]*b[0] + a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
```

Element `k` of `a` is `a[8*k +: 8]`, the same for `b`. The stub does
everything in one clock cycle: four multipliers and three adders between
two registers. That is far too slow for a fast FPGA clock.

## Task

Rewrite `dot4.v` with **three pipeline stages**:

| Stage | Registers after this stage |
|---|---|
| 1 | four 16-bit products |
| 2 | two 17-bit sums of two products |
| 3 | the 18-bit result `y` |

- `valid_out` must be `valid_in` delayed by exactly 3 clock cycles.
- `y` must belong to the inputs that were sampled 3 edges earlier.
- Synchronous reset `rst` clears the valid pipeline (data registers need no reset).
- A new input can arrive every cycle (throughput: one result per cycle).

## Hints

- Look at `examples/13-towards-fpga/pipelined-adder-tree`.
- Draw the pipeline first, with the widths of every register.

## Run

```bash
make run DIR=exercises/13-towards-fpga/ex2-pipeline-it
```

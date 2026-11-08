# Exercise 04.3: find and fix the latches

`light_decode.v` drives three traffic lights from a 2-bit state.
It was written quickly, and it has **three** bugs that create latches.
The testbench fails.

## Specification

| emergency | state | red | yellow | green |
|---|---|---|---|---|
| 1 | any | 1 | 0 | 0 |
| 0 | 0 | 1 | 0 | 0 |
| 0 | 1 | 0 | 0 | 1 |
| 0 | 2 | 0 | 1 | 0 |
| 0 | 3 | 0 | 0 | 0 (all off) |

## Task

1. Read the code. For every output, ask: "Is it assigned in **every** path
   through the `always` block?"
2. Fix the code. Keep the structure (`if` and `case`). The cleanest fix is
   default values at the top of the block.
3. Run the testbench until it passes.

## Bonus

If you have Yosys, synthesize the original file and look for
`Latch inferred` messages:

```bash
yosys -p "read_verilog light_decode.v; synth" | grep -i latch
```

## Run

```bash
make run DIR=exercises/04-combinational-logic/ex3-fix-the-latch
```

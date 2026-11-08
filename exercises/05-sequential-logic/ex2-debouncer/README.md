# Exercise 05.2: button debouncer

A mechanical button does not switch cleanly. For a few milliseconds its
contact bounces between 0 and 1. A **debouncer** changes its output only
after the input has been stable for some time.

## Task

Complete `debounce.v`. Use a small counter `cnt`. At each rising edge of `clk`:

1. If `rst` is 1: `btn_out <= 0`, `cnt <= 0`.
2. Else, if `btn_in` is equal to `btn_out`: nothing to do, `cnt <= 0`.
3. Else, if `cnt` has reached `STABLE - 1`: the input has been different for
   `STABLE` edges in a row, so `btn_out <= btn_in` and `cnt <= 0`.
4. Else: `cnt <= cnt + 1`.

`STABLE` is a `localparam` equal to 4. (On a real board you would use
about 10 ms worth of clock cycles, for example 500 000 at 50 MHz.)

```text
clk edge   1  2  3  4  5  6  7  8  9 10
btn_in     1  0  1  1  1  1  1  1  0  1     (bounces, then stable)
cnt        1  0  1  2  3  0  0  0  1  0
btn_out    0  0  0  0  0  1  1  1  1  1     (changes at edge 6)
```

## Hints

- Two registers: `btn_out` (the output) and `cnt` (2 bits are enough for 4).
- One `always @(posedge clk)` block with `if / else if`.

## Run

```bash
make run DIR=exercises/05-sequential-logic/ex2-debouncer
```

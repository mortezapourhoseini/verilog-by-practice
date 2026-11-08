# Exercise 05.1: 8-bit up/down counter with load

## Task

Complete `up_down_counter8.v`. All changes happen at the rising edge of `clk`.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `clk` | input | 1 | clock |
| `rst` | input | 1 | synchronous reset to 0, highest priority |
| `load` | input | 1 | copy `load_value` into the counter (second priority) |
| `load_value` | input | 8 | value for `load` |
| `en` | input | 1 | count only when 1 |
| `up` | input | 1 | 1 = count up, 0 = count down |
| `count` | output reg | 8 | the counter value |

The counter wraps around: `255 + 1 = 0` and `0 - 1 = 255`.

Priority: `rst` > `load` > `en`.

## Hints

- One `always @(posedge clk)` block with `if / else if` in priority order.
- Use only `<=` in the clocked block.

## Run

```bash
make run DIR=exercises/05-sequential-logic/ex1-up-down-counter
```

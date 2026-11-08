# Exercise 04.1: 3-to-8 decoder with enable

## Task

Complete `decoder3to8.v`. When `en` is 1, exactly one output bit is 1:
the bit with index `sel`. When `en` is 0, all outputs are 0.

```text
en=1 sel=0 -> y = 8'b0000_0001
en=1 sel=5 -> y = 8'b0010_0000
en=0 sel=5 -> y = 8'b0000_0000
```

| Port | Direction | Width |
|---|---|---|
| `en` | input | 1 |
| `sel` | input | 3 |
| `y` | output reg | 8 |

## Rules

- Use an `always @(*)` block with a `case` statement.
- Make sure no latch can appear. (What value does `y` have when `en` is 0?)

## Bonus

Write a second version in one line with a shift: `assign y = ...;`.

## Run

```bash
make run DIR=exercises/04-combinational-logic/ex1-decoder3to8
```

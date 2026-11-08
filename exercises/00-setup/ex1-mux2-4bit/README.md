# Exercise 00.1: 4-bit 2-to-1 multiplexer

## Task

Complete `mux2_4bit.v`. The module selects one of two 4-bit buses.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `a` | input | 4 | selected when `sel` is 0 |
| `b` | input | 4 | selected when `sel` is 1 |
| `sel` | input | 1 | select signal |
| `y` | output | 4 | the selected bus |

## Hints

- The conditional operator `? :` works on buses too, not only on single bits.
- Do not forget the width `[3:0]` on every bus port.

## Run

```bash
make run DIR=exercises/00-setup/ex1-mux2-4bit
```

The testbench tries all 512 combinations of `a`, `b` and `sel`.

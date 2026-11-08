# Exercise 04.2: count leading zeros

Many processors have a "count leading zeros" instruction. It is used for
normalizing floating-point numbers and for fast logarithms.

## Task

Complete `clz8.v`. `count` is the number of 0 bits **before the first 1**,
counted from the most significant bit. If `d` is 0, `count` is 8.

```text
d = 8'b1000_0000 -> count = 0
d = 8'b0001_0110 -> count = 3
d = 8'b0000_0001 -> count = 7
d = 8'b0000_0000 -> count = 8
```

| Port | Direction | Width |
|---|---|---|
| `d` | input | 8 |
| `count` | output reg | 4 |

## Hints

- Look at the priority encoder example. This is almost the same problem.
- With a `for` loop: start with `count = 8`. Which loop direction makes the
  correct bit win?
- Or use `casez` with `?` bits.

## Run

```bash
make run DIR=exercises/04-combinational-logic/ex2-leading-zeros
```

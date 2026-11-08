# Exercise 01.2: 8-bit adder from two 4-bit adders

## Task

Complete `adder8.v`. Use **two instances** of the given `ripple_adder4`
module (which itself uses `full_adder`). Do not use the `+` operator.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `a`, `b` | input | 8 | operands |
| `cin` | input | 1 | carry in |
| `sum` | output | 8 | `a + b + cin`, low 8 bits |
| `cout` | output | 1 | carry out of bit 7 |

## Hints

- The low adder works on bits `[3:0]`, the high adder on bits `[7:4]`.
- The carry out of the low adder goes into the carry in of the high adder.
  You need one internal wire for it.
- You can connect a part of a vector to a port: `.a(a[7:4])`.

## Run

```bash
make run DIR=exercises/01-modules-and-ports/ex2-adder8
```

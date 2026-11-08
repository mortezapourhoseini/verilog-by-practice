# Exercise 02.1: zero extension and sign extension

## Task

Complete `extend.v`. It makes a 16-bit value from an 8-bit value in two ways.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `in` | input | 8 | the input value |
| `zext` | output | 16 | `in` as an **unsigned** number (fill the high byte with 0) |
| `sext` | output | 16 | `in` as a **signed** (two's complement) number (fill the high byte with the sign bit `in[7]`) |

Examples:

```text
in = 8'h05  (5)     -> zext = 16'h0005, sext = 16'h0005  (5)
in = 8'hFB  (-5)    -> zext = 16'h00FB, sext = 16'hFFFB  (-5)
in = 8'h80  (-128)  -> zext = 16'h0080, sext = 16'hFF80  (-128)
```

## Hints

- Concatenation `{a, b}` joins two vectors.
- Replication `{8{x}}` repeats `x` eight times (chapter 03 has more on it).
- Do not use the `signed` keyword in this exercise. Build the bits yourself.

## Run

```bash
make run DIR=exercises/02-data-types-vectors-literals/ex1-sign-extend
```

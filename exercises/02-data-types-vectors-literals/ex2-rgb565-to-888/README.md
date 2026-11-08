# Exercise 02.2: unpack an RGB565 pixel to RGB888

Small displays and cameras often use 16-bit **RGB565** pixels:

```text
bit:   15 14 13 12 11 | 10  9  8  7  6  5 |  4  3  2  1  0
       R4 R3 R2 R1 R0 | G5 G4 G3 G2 G1 G0 | B4 B3 B2 B1 B0
```

## Task

Complete `rgb565_to_888.v`. Make three 8-bit color values.

To scale a 5-bit value to 8 bits, put the 5 bits on top and **repeat its
3 highest bits** below them. For a 6-bit value, repeat its 2 highest bits.
This maps `0` to `0` and the maximum (`31` or `63`) to `255`.

```text
r5 = 5'b11111 -> r8 = 8'b11111_111 = 255
r5 = 5'b10000 -> r8 = 8'b10000_100 = 132
g6 = 6'b100000 -> g8 = 8'b100000_10 = 130
```

| Port | Direction | Width |
|---|---|---|
| `pix` | input | 16 |
| `r8`, `g8`, `b8` | output | 8 each |

## Hints

- First think: which bits of `pix` are `r5`, `g6` and `b5`?
- Use part selects and concatenation. One `assign` per output is enough.

## Run

```bash
make run DIR=exercises/02-data-types-vectors-literals/ex2-rgb565-to-888
```

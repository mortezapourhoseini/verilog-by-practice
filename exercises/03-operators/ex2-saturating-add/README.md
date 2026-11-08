# Exercise 03.2: saturating adders

In signal processing, an overflow that wraps around is very bad: a loud
sound becomes a click, a bright pixel becomes black. A **saturating** adder
returns the largest (or smallest) value instead.

## Task

Complete `sat_add8.v`.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `a`, `b` | input | 8 | operands |
| `usum` | output | 8 | unsigned sum. If it does not fit, `255`. |
| `ssum` | output | 8 | signed (two's complement) sum. Clamp to `127` or `-128`. |

```text
unsigned: 200 + 100 = 300 -> usum = 255
signed:   100 + 100 = 200 -> ssum = 127   (8'h7F)
signed:  -100 + -100 = -200 -> ssum = -128 (8'h80)
signed:   100 + -100 = 0    -> ssum = 0    (no overflow is possible)
```

## Hints

- Unsigned: make the sum 9 bits wide. Bit 8 tells you if it overflowed.
- Signed: an overflow happens only when `a` and `b` have the **same** sign,
  and the 8-bit sum has a **different** sign. Then the correct clamp value
  depends on the sign of `a`.
- `? :` is enough. You do not need `signed` declarations.

## Run

```bash
make run DIR=exercises/03-operators/ex2-saturating-add
```

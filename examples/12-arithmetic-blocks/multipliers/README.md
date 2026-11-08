# Example: combinational and sequential multipliers

| Module | How | Cost | Latency |
|---|---|---|---|
| `mult8` | `*`, signed or unsigned | one DSP block (or many LUTs) | 0 cycles |
| `mult_seq8` | shift and add, one bit per cycle | one 16-bit adder and a few registers | 8 cycles + 1 |

## Run

```bash
make run DIR=examples/12-arithmetic-blocks/multipliers
```

## Shift and add

Binary long multiplication. For each bit of `b` (from the right), add `a`
shifted to that position if the bit is 1:

```text
      1011      a = 11
    x 0110      b = 6
    ------
      0000      b[0] = 0
     1011       b[1] = 1
    1011        b[2] = 1
   0000         b[3] = 0
   -------
   1000010      = 66
```

## What to look at

- `$signed(a) * $signed(b)`: if only one operand is signed, the product is
  computed as unsigned and is wrong for negative inputs (exercise 12.1).
- The sequential version trades **time for area**. That is a basic design
  decision you will meet again and again.

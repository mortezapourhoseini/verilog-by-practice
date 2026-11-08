# Example: 8-bit ALU

| op | Name | Result |
|---|---|---|
| 0 | ADD | `{carry, y} = a + b` |
| 1 | SUB | `{carry, y} = a - b` (carry = borrow) |
| 2 | AND | `a & b` |
| 3 | OR | `a \| b` |
| 4 | XOR | `a ^ b` |
| 5 | NOR | `~(a \| b)` |
| 6 | SHL | `a << b[2:0]` |
| 7 | SHR | `a >> b[2:0]` |
| 8 | SRA | `$signed(a) >>> b[2:0]` |
| 9 | SLT | `1` if `a < b` as signed numbers |
| 10 | SLTU | `1` if `a < b` as unsigned numbers |

`zero` is `~|y` (reduction NOR).

## Run

```bash
make run DIR=examples/03-operators/alu8
```

## What to look at

- `{carry, y} = a + b;` gets the carry for free, because the left side is 9 bits.
- `$signed(a) >>> n` versus `a >> n`: try `a = 8'h80`, `n = 3`.
  The first gives `8'hF0`, the second `8'h10`.
- `$signed(a) < $signed(b)` versus `a < b`: for `a = 8'hFF`, `b = 8'h01`,
  the signed compare is true (-1 < 1), the unsigned one is false (255 < 1).
- The reference model in the testbench does not use `>>>` or `$signed`.
  A model written in a different way finds more bugs.

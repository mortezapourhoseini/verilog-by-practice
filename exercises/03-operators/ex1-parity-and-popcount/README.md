# Exercise 03.1: parity bit and population count

## Task

Complete `bitcount8.v`.

| Port | Direction | Width | Meaning |
|---|---|---|---|
| `d` | input | 8 | data |
| `parity` | output | 1 | 1 if `d` has an **odd** number of 1 bits |
| `ones` | output | 4 | how many bits of `d` are 1 (0 to 8) |

```text
d = 8'b0000_0000 -> parity = 0, ones = 0
d = 8'b1011_0001 -> parity = 0, ones = 4
d = 8'b1111_1110 -> parity = 1, ones = 7
```

## Hints

- One reduction operator gives the parity.
- For `ones`, you can add the 8 single bits. Think about the width rule:
  why is the result correct even though each operand is only 1 bit wide?
- No loops are needed (loops come in chapter 04).

## Run

```bash
make run DIR=exercises/03-operators/ex1-parity-and-popcount
```

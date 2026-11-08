# Exercise 12.1: a signed multiplier that is really signed

`smul8.v` should multiply two **signed** (two's complement) 8-bit numbers
and give the full 16-bit signed product. The ports are declared as plain
`wire [7:0]`, as they often are in real projects. The stub uses `a * b`.

```text
  3 *  5 =   15   -> 16'h000F
 -3 *  5 =  -15   -> 16'hFFF1
 -3 * -5 =   15   -> 16'h000F
-128 * -128 = 16384 -> 16'h4000
```

## Task

1. Run the testbench first. It fails for every negative input. Why does
   `a * b` give `16'h04F1` for `-3 * 5`? (Hint: what is 253 * 5?)
2. Fix `smul8.v` so that all 65536 cases pass. Keep the port declarations.

## Hints

- Chapter 03: an expression is signed only if **all** operands are signed.
- `$signed(x)` reads `x` as a signed number.
- Bonus: write a second version without `$signed`, by sign-extending both
  operands to 16 bits yourself and multiplying the 16-bit values.

## Run

```bash
make run DIR=exercises/12-arithmetic-blocks/ex1-signed-multiply
```

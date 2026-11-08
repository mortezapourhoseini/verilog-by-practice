# Exercise 13.1: find the LUT INIT values

`lut_functions.v` has four `lut4` instances (the model from
`examples/13-towards-fpga/lut-model`). Their `INIT` values are all 0.

## Task

Compute the 16-bit `INIT` value for each function and write it into the file.
The address is `n = {i3, i2, i1, i0}`, and bit `n` of INIT is the output for
that address.

| Output | Function | Inputs used |
|---|---|---|
| `f_mux` | `i2 ? i1 : i0` (a 2-to-1 mux) | i0, i1, i2 |
| `f_and4` | `i0 & i1 & i2 & i3` | all |
| `f_xor4` | `i0 ^ i1 ^ i2 ^ i3` | all |
| `f_atleast2` | 1 if two or more inputs are 1 | all |

## Method

1. Write the truth table with 16 rows, `n = 0 .. 15`.
2. Write the output column from row 15 down to row 0. That is INIT in binary.
3. Group it in nibbles and write it in hex.

If a function does not use `i3`, rows 8 to 15 repeat rows 0 to 7.

## Run

```bash
make run DIR=exercises/13-towards-fpga/ex1-lut-init
```

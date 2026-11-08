# Exercise 09.2: a file-driven testbench for a BCD converter

`bin2bcd.v` converts an 8-bit number to three decimal digits (BCD):
`8'd237 -> hundreds = 2, tens = 3, ones = 7`.

`bcd_vectors.txt` contains the expected result for all 256 inputs. A Python
script wrote it, so the reference model is outside Verilog:

```text
// comment lines start with //
0 0 0 0
1 0 0 1
...
255 2 5 5
```

Format (decimal): `value hundreds tens ones`.

## Task

Complete `tb_bcd.v`. Your testbench must:

1. open `bcd_vectors.txt` with `$fopen`, and fail clearly if it cannot,
2. read it line by line (`$fgets` and `$sscanf`, or `$fscanf`),
   and skip comment lines,
3. apply each value to the DUT and compare the three digits,
4. count the vectors and fail if it did not read exactly **256**,
5. print one `PASS: tb_bcd` or `FAIL: tb_bcd ...` line.

Use `examples/09-testbenches/file-io/tb_abs_diff.v` as a template.

## Bonus

Write the results to `bcd_out.txt` with `$fdisplay`, in the same format, and
compare the two files with `diff`. (`*_out.txt` files are ignored by git.)

## Run

```bash
make run DIR=exercises/09-testbenches/ex2-file-driven-test
```

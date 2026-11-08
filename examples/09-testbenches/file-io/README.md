# Example: file-driven testbench

| File | What it is |
|---|---|
| `abs_diff.v` | DUT: the absolute difference of `a` and `b` |
| `vectors.txt` | Test vectors, `a b expected` in hex, with comment lines |
| `tb_abs_diff.v` | Reads the file line by line, checks each vector, writes `results_out.txt` |

## Run

```bash
make run DIR=examples/09-testbenches/file-io
cat examples/09-testbenches/file-io/results_out.txt
```

## Why file-driven tests?

- The **reference model** can be written in another language (Python,
  MATLAB, C), where it is short and easy to trust. The script writes
  `vectors.txt`, and the testbench only compares.
- The same vectors can test the design at different stages (RTL, after
  synthesis, on the board).
- Adding a test means adding a line, not changing Verilog code.

Results files end in `_out.txt`, which `.gitignore` ignores.

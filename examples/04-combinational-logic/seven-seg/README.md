# Example: hex to seven-segment decoder

A `case` statement that covers all 16 input values: a small lookup table.

| File | What it is |
|---|---|
| `hex_to_7seg.v` | `always @(*)` with a 16-line `case` |
| `tb_hex_to_7seg.v` | Compares with segment names like `"abdeg"`, and draws digit 2 in the log |

## Run

```bash
make run DIR=examples/04-combinational-logic/seven-seg
```

## What to look at

- The output is `output reg`, because it is assigned in `always`. It is still
  pure combinational logic.
- The testbench reference is written in a different form (segment names,
  not bit patterns). Copying the design's table into the testbench would
  copy its mistakes too.

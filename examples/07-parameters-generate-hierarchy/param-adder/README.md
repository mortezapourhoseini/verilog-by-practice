# Example: parameterized ripple-carry adder with a generate loop

| File | What it is |
|---|---|
| `full_adder.v` | One-bit full adder |
| `ripple_adder.v` | `parameter WIDTH` and a `generate for` loop that creates WIDTH full adders |
| `tb_ripple_adder.v` | Two instances: `#(.WIDTH(4))` tested exhaustively, `#(.WIDTH(12))` tested randomly |

## Run

```bash
make run DIR=examples/07-parameters-generate-hierarchy/param-adder
```

## What to look at

- `genvar i;` and `for (...) begin : bit_slice`: the name `bit_slice` is
  required for a clean hierarchy. Instance names become
  `add12.bit_slice[0].fa`, `add12.bit_slice[1].fa`, ...
- In GTKWave, open `add12` and you will see the `bit_slice[...]` scopes.
- The same file makes a 4-bit and a 12-bit adder. Compare with the four
  hand-written lines in chapter 01.

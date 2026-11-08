# Example: 8-bit priority encoder (two coding styles)

The output `idx` is the position of the highest `1` in `req`.
`valid` is 0 when no bit is set.

| File | What it is |
|---|---|
| `priority_encoder8.v` | Two modules: a `for` loop version and a `casez` version |
| `tb_priority_encoder8.v` | Tests both on all 256 inputs against a `while`-loop model |

## Run

```bash
make run DIR=examples/04-combinational-logic/priority-encoder
```

## What to look at

- **Loop version:** the loop is unrolled into 8 `if` statements. The last
  matching `if` wins, so the loop counts **up** to give priority to the
  highest bit.
- **casez version:** `?` marks bits that do not matter. The first matching
  line wins. This style shows the truth table directly.
- Both versions start with default values, so no latch can appear.
- The testbench has two DUTs. Comparing two implementations with one model
  is a cheap way to test coding styles.

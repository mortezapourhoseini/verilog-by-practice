# Example: selecting bits and bytes from a word

| File | What it is |
|---|---|
| `field_extract.v` | Byte select with `+:`, byte swap with `{ }`, bit and part selects |
| `tb_field_extract.v` | One fixed value (`32'hDEAD_BEEF`) and 200 random words |

## Run

```bash
make run DIR=examples/02-data-types-vectors-literals/field-extract
```

## What to look at

- `word[byte_sel*8 +: 8]`: the start bit can change at run time,
  the width must be a constant.
- `{word[7:0], word[15:8], ...}`: the first item in `{ }` becomes the most significant part.
- In the testbench, `exp_byte = word >> (byte_sel*8)` truncates the 32-bit
  result to 8 bits automatically. That is a quick reference model.

```text
word      = de ad be ef
byte_sel  = 0 -> ef, 1 -> be, 2 -> ad, 3 -> de
swapped   = ef be ad de
```

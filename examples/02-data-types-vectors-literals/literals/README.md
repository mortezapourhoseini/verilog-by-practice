# Example: literals and value rules

A testbench without a design. Each line checks one rule from
[chapter 02](../../../docs/02-data-types-vectors-literals.md): sizes,
extension, truncation, x and z, signed values, selects and strings.

## Run

```bash
make run DIR=examples/02-data-types-vectors-literals/literals
```

Every rule prints one `ok` line. Read them next to the source code.

## Try this

Change one expected value, for example `8'b0000_xxxx` to `8'bxxxx_xxxx`,
and run again. The check fails and shows the real value. This is a fast way
to answer "what does Verilog do here?" questions for yourself.

# Example: register file (2 read ports, 1 write port)

| File | What it is |
|---|---|
| `regfile.v` | 8 x 8-bit registers, register 0 is always 0, asynchronous read, synchronous write |
| `tb_regfile.v` | 2000 random cycles against a model array |

## Run

```bash
make run DIR=examples/08-memories/register-file
```

## What to look at

- The read ports are `assign` statements: the data changes as soon as the
  address changes, without a clock.
- The write port is clocked. A value written at edge `n` can be read right
  after edge `n`.
- Register 0 is handled twice: writes are ignored, and reads return 0.
  Either one alone would be enough, but doing both makes the intent clear.

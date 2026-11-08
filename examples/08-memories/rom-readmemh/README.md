# Example: ROM loaded with `$readmemh`

| File | What it is |
|---|---|
| `squares.hex` | 16 hex values, one per line, with comments |
| `rom_squares.v` | `reg [7:0] mem [0:15];`, `$readmemh`, synchronous read |
| `tb_rom_squares.v` | Reads every address, checks `data = addr * addr` one cycle later |

## Run

```bash
make run DIR=examples/08-memories/rom-readmemh
```

`make run` runs the simulation **inside this folder**, so `$readmemh`
finds `squares.hex`. If you run `vvp` from another folder, you get:

```text
WARNING: rom_squares.v:24: $readmemh(squares.hex): Unable to open squares.hex for reading.
```

and the ROM is full of `x`.

## The hex file format

```text
// comments are allowed
@0          <- optional: the address of the next value
00          <- one value per line (spaces and newlines separate values)
01
04
```

`$readmemb` does the same with binary digits.

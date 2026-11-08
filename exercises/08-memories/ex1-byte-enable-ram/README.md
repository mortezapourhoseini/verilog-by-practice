# Exercise 08.1: RAM with byte enables

Processors often write only one byte of a 32-bit word (for example a C
`char` store). The memory then needs a **byte enable** for each byte lane.

## Task

Complete `ram_be.v`: 16 words of 32 bits.

| Port | Width | Meaning |
|---|---|---|
| `clk` | 1 | clock |
| `be` | 4 | byte enables. `be[i] = 1` writes byte `i` (`din[8*i+7 : 8*i]`) |
| `addr` | 4 | word address |
| `din` | 32 | write data |
| `dout` | 32 | read data, synchronous, **read-first** (old value) |

A write happens at the rising edge for every byte with `be[i] = 1`.
The other bytes of the word keep their value. `be = 4'b0000` means "read only".

```text
mem[3] = 11223344
write addr=3 be=0010 din=xxxxAAxx  ->  mem[3] = 1122AA44
```

## Hints

- Start from `examples/08-memories/single-port-ram/ram_sp.v`.
- Four `if` statements, one per byte lane, each with an indexed part select.
- Keep the read in the same clocked block (read-first).

## Run

```bash
make run DIR=exercises/08-memories/ex1-byte-enable-ram
```

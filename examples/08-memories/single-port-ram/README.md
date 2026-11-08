# Example: single-port RAM (block RAM style)

| File | What it is |
|---|---|
| `ram_sp.v` | `reg [DATA_W-1:0] mem [0:DEPTH-1]`, synchronous write and read, read-first |
| `tb_ram_sp.v` | Fills the RAM, shows read-first behaviour, then 1000 random cycles against a model |

## Run

```bash
make run DIR=examples/08-memories/single-port-ram
```

## Read-first timing

```text
clk edge     1          2
addr         5          5
we           1          0
din          AA         -
dout (after) old mem[5] AA
```

## What to look at

- Read and write are in the **same** clocked block, with `<=`. So the read
  sees the old contents. That is "read-first".
- The model in the testbench is also a memory array, updated at the same
  clock edge, so the comparison is exact cycle by cycle.
- Icarus does not write memory arrays to the VCD file by default. To see a
  word in GTKWave, add a wire in the testbench, for example
  `wire [7:0] word5 = dut.mem[5];`.

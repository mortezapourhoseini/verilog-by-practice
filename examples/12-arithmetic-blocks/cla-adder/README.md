# Example: 4-bit carry-lookahead adder

| File | What it is |
|---|---|
| `cla4.v` | Generate/propagate signals and parallel carry equations |
| `tb_cla4.v` | All 512 inputs compared with `a + b + cin` |

## Run

```bash
make run DIR=examples/12-arithmetic-blocks/cla-adder
```

## Should you write adders by hand?

Usually **no**. Write `assign {cout, sum} = a + b + cin;` and let the tool
choose. FPGAs have dedicated fast carry chains, and the `+` operator maps
straight onto them. A hand-written lookahead adder may even be slower on an
FPGA, because it does not use the carry chain.

Knowing how a CLA works still matters: it explains why wide adders are
slow, why pipelining helps, and how ASIC tools build fast adders.

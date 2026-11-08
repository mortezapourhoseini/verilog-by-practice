# Example: SystemVerilog features in a design and a testbench

| File | Features |
|---|---|
| `traffic_fsm.sv` | `logic`, `typedef enum`, `always_ff`, `always_comb`, `unique case`, `'0` |
| `tb_traffic_fsm.sv` | `int`, `++`, `+=`, `.*` connections, `task automatic`, `$urandom_range`, `assert ... else $error` |

## Run

```bash
make run DIR=examples/appendix-systemverilog/sv-testbench
```

The scripts see the `.sv` files and compile with `iverilog -g2012`.
By hand:

```bash
cd examples/appendix-systemverilog/sv-testbench
iverilog -g2012 -Wall -o sim.vvp traffic_fsm.sv tb_traffic_fsm.sv
vvp sim.vvp
```

See the [SystemVerilog appendix](../../../docs/appendix-systemverilog.md).

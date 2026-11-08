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

## Expected messages

```text
traffic_fsm.sv:41: vvp.tgt sorry: Case unique/unique0 qualities are ignored.
WARNING: traffic_fsm.sv:41: value is unhandled for priority or unique case statement
         Time: 0  Scope: tb_traffic_fsm.dut
...
403 cycles, side road got green 30 times
PASS: tb_traffic_fsm
```

The warnings at time 0 are useful: before the reset, `state` is `x`, and
`unique case` reports that no item matches. A plain `case` would stay silent.
Icarus checks this at run time but does not use `unique` for optimization
(the "sorry" line).

See the [SystemVerilog appendix](../../../docs/appendix-systemverilog.md).

# Example: behavioural model versus RTL

| Module | Style | Synthesizable? |
|---|---|---|
| `pulse_model` | `initial`, `forever`, `repeat`, `@(posedge clk)` inside the loop, `#1` delays | no |
| `pulse_rtl` | one `always @(posedge clk)` with a counter | yes |

The testbench checks that both produce the same pulse train: one pulse
every 8 cycles.

## Run

```bash
make run DIR=examples/10-synthesizable-vs-simulation/model-vs-rtl
```

## Why have both?

A behavioural model is quick to write and easy to read. It is a good
**reference** for the RTL, and a good model of things outside the chip
(a sensor, a memory, a UART on the other side of a cable).

The file `SIM_ONLY` in this folder tells the optional lint/synthesis script
(`make lint`) to skip this example, because `pulse_model` is not hardware.

# Example: tri-state bus (z and x on a wire)

Two `bus_driver` instances drive the same `wire`.

| en_a | en_b | bus |
|---|---|---|
| 0 | 0 | `zzzzzzzz` (nobody drives) |
| 1 | 0 | `data_a` |
| 0 | 1 | `data_b` |
| 1 | 1 | `x` where the two values differ (a short circuit in real hardware) |

## Run

```bash
make run DIR=examples/02-data-types-vectors-literals/tristate-bus
```

In GTKWave, `z` is usually drawn as a line in the middle, and `x` in red.

Tri-state buses are fine on I/O pins. Inside an FPGA, use a multiplexer instead.

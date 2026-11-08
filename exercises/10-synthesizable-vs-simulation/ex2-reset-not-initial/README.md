# Exercise 10.2: use a reset, not an initial value

`event_counter.v` counts `tick` pulses. Its author used `initial count = 0;`
instead of a reset. In simulation it looks fine. But:

- on an ASIC, `initial` does nothing: the register starts with a random value,
- on an FPGA, the initial value is used once at power-up, but **not** when
  the system is reset later,
- the `rst` input exists, but the code ignores it.

## Task

Fix `event_counter.v`:

1. Remove the `initial` block.
2. Make `rst` (synchronous, active high) clear `count`.
3. Keep the counting behaviour: `count <= count + 1` when `tick` is 1.
   The counter wraps from 255 to 0.

## How the testbench finds the bug

The testbench writes a random value into the register at time 1, before
the reset, with a hierarchical assignment (`dut.count = 8'hA5;`). This
simulates a chip that powers up with garbage. A correct design clears it
during reset. It then also resets the counter in the middle of counting.

## Run

```bash
make run DIR=exercises/10-synthesizable-vs-simulation/ex2-reset-not-initial
```

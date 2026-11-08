# Example: a testbench template (the toolkit)

`tb_accumulator.v` is a template. Copy it when you start a new testbench.

| Part | What it shows |
|---|---|
| Settings | `CLK_PERIOD` and `TIMEOUT` as `localparam`s |
| Clock | `forever #(CLK_PERIOD/2) clk = ~clk;` |
| Watchdog | an `initial` block that fails the test after `TIMEOUT` |
| Tasks | `reset_dut`, `send`, `do_clear` (drivers), `check_sum` (checker) |
| Model | `expected`, updated by the driver tasks |
| Printing | `$timeformat` with `%t`, `$monitor` / `$monitoroff`, `$display` vs `$strobe` |
| Report | one `PASS:` or `FAIL:` line, `$fatal` on failure |

## Run

```bash
make run DIR=examples/09-testbenches/tb-toolkit
```

## Part of the output

```text
monitor:    20.0 ns  valid=1 din=0a sum=0
monitor:    25.0 ns  valid=1 din=0a sum=10
monitor:    30.0 ns  valid=1 din=14 sum=10
...
at the edge, $display sees the OLD sum: 60
at the edge, $strobe  sees the NEW sum: 61
```

`$strobe` prints at the end of the time step, after the non-blocking
assignments. `$display` prints at once, before them.

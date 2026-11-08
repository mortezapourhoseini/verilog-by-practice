# Example: parameterized delay line (generate if and generate for)

`delay_line #(.WIDTH(W), .DEPTH(D))` delays a W-bit signal by D clock cycles.

| Instance in the testbench | Hardware |
|---|---|
| `#(.WIDTH(8), .DEPTH(0))` | `generate if` picks a plain wire |
| `#(.WIDTH(8), .DEPTH(3))` | 3 registers of 8 bits |
| `#(.WIDTH(4), .DEPTH(5))` | 5 registers of 4 bits |

## Run

```bash
make run DIR=examples/07-parameters-generate-hierarchy/delay-line
```

The first lines of the output come from the `initial $display` in the module:

```text
delay_line: WIDTH=8 DEPTH=0 -> 0 flip-flops
delay_line: WIDTH=8 DEPTH=3 -> 24 flip-flops
delay_line: WIDTH=4 DEPTH=5 -> 20 flip-flops
```

## What to look at

- `wire [WIDTH-1:0] stage [0:DEPTH];` is an **array of wires**, new in
  Verilog-2001. It is declared inside the generate block, so it only exists
  when `DEPTH > 0`.
- Each loop iteration declares its own `reg r`. Its full name is
  `d3.with_delay.reg_stage[2].r`.

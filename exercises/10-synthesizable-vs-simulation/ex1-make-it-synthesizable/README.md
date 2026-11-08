# Exercise 10.1: turn a behavioural model into RTL

Someone wrote this LED blinker as a behavioural model. It works in
simulation, but it cannot be synthesized:

```verilog
// NOT synthesizable
initial begin
  led = 1'b0;
  @(negedge rst);
  forever begin
    repeat (HALF) @(posedge clk);
    #1 led = ~led;
  end
end
```

After reset is released, `led` toggles at every `HALF`-th rising clock edge.
With `HALF = 5`: the LED is 0 for 5 cycles, 1 for 5 cycles, and so on.

## Task

Complete `blinker.v` as **synthesizable RTL**:

- one `always @(posedge clk)` block, non-blocking assignments only,
- a counter from 0 to `HALF - 1`,
- synchronous reset: `led <= 0`, counter `<= 0`,
- no `initial`, no `#` delays, no `forever`.

```text
edge after reset  1 2 3 4 5 6 7 8 9 10 11
led (after edge)  0 0 0 0 1 1 1 1 1 0  0
```

## Check

The testbench compares your RTL with the behavioural model above (it is
inside the testbench) for 200 cycles. If you have Yosys, also run:

```bash
yosys -p "read_verilog blinker.v; synth; stat"
```

## Run

```bash
make run DIR=exercises/10-synthesizable-vs-simulation/ex1-make-it-synthesizable
```

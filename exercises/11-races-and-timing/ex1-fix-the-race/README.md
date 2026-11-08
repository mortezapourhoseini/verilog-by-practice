# Exercise 11.1: fix the race in a pipeline

`pipe3.v` should delay `din` by three clock cycles. Its author put each
pipeline stage in its own `always` block, and used blocking assignments.

```verilog
always @(posedge clk) q1 = din;
always @(posedge clk) q2 = q1;
always @(posedge clk) q3 = q2;
```

The testbench fails: in Icarus, `dout` is delayed by less than three cycles.

## Task

1. Before you change anything, explain the failure: in which order does the
   simulator run the three blocks at a clock edge, and what does each block
   read?
2. Try this: reverse the order of the three blocks in the file
   (`q3` first, then `q2`, then `q1`) and run again. What happens? Why is that
   **not** a fix?
3. Fix the code properly, so that it works in **any** order.

## Run

```bash
make run DIR=exercises/11-races-and-timing/ex1-fix-the-race
```

# Example: blocking (`=`) versus non-blocking (`<=`) in clocked blocks

The same three lines, written with `<=` and with `=`:

```verilog
q1 <= d;     q2 <= q1;    q3 <= q2;    // 3 flip-flops: delay of 3 cycles
q1 =  d;     q2 =  q1;    q3 =  q2;    // all equal d: delay of 1 cycle
```

## Run

```bash
make run DIR=examples/05-sequential-logic/blocking-vs-nonblocking
```

## Output (shortened)

```text
cycle  5: d(sampled)= 50   non-blocking q1,q2,q3 =  50  40  30   blocking =  50  50  50
cycle  6: d(sampled)= 60   non-blocking q1,q2,q3 =  60  50  40   blocking =  60  60  60
```

With `<=`, every register gets the **old** value of the one before it.
With `=`, each line sees the **new** value of the line above, so the chain
collapses. Synthesis agrees: for the blocking version, Yosys builds only
8 flip-flops (one 8-bit register shared by `q1`, `q2` and `q3`). For the
non-blocking version it builds 24 (three 8-bit registers). Run `make lint`
to see the cell counts.

**Rule:** in `always @(posedge clk)`, use only `<=`.

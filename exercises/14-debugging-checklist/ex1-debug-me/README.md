# Exercise 14.1: debug me

`avg4.v` computes a moving average: when `valid` is 1, it outputs the
average (rounded down) of the current sample and the three previous **valid**
samples. The result is registered: `avg` and `out_valid` appear one cycle
after the input. At reset, the history is 0.

```text
valid  1    1    1    1    0    0    1
din    200  200  200  200  -    -    100
avg       50  100  150  200 (hold)    175   (one cycle later)
```

The code has **three bugs**. The testbench fails.

## Task

Do not guess. Work through the checklist in
[docs/14-debugging-checklist.md](../../../docs/14-debugging-checklist.md):

1. Compile with `-Wall`. Run `make lint` if you have Verilator. Read every warning.
2. Run the testbench and read the **first** error, not the last one.
3. Open the waveform. Add `din`, `valid`, `dut.s0`, `dut.s1`, `dut.s2`,
   `dut.sum`, `avg`. Go to the time of the first error.
4. For each bug: write down the symptom, the cause and the fix.

## Run

```bash
make run DIR=exercises/14-debugging-checklist/ex1-debug-me
make wave DIR=exercises/14-debugging-checklist/ex1-debug-me
```

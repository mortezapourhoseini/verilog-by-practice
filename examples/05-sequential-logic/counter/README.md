# Example: 4-bit counter with enable and wrap pulse

| File | What it is |
|---|---|
| `counter.v` | `count <= count + 1` with synchronous reset and enable, plus a `wrap` pulse |
| `tb_counter.v` | A model counter in the testbench, compared at every clock edge |

## Run

```bash
make run DIR=examples/05-sequential-logic/counter
make wave DIR=examples/05-sequential-logic/counter
```

## Waveform

```text
clk    _/~\_/~\_/~\_/~\_/~\_/~\_/~\_
en     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
count   13 | 14 | 15 |  0 |  1 |  2
wrap   ________/~~~\________________
```

`wrap` is 1 during the cycle where `count` is 15. At the next rising edge,
the counter goes to 0.

## What to look at

- The register part (`always @(posedge clk)`) and the combinational part
  (`assign wrap = ...`) are separate. This is a good habit.
- The testbench has its own counter (`model`) with the same rules, written
  with an integer and `% 16`.
- Inputs change at the **falling** edge, checks run at the **rising** edge.
  Chapter 09 and chapter 11 explain why this order is safe.

# Example: random stimulus, property checks and coverage

| File | What it is |
|---|---|
| `sort3.v` | Sorts three bytes with three compare-and-swap steps |
| `tb_sort3.v` | 5000 weighted random cases, checks two properties, counts coverage |

## Run

```bash
make run DIR=examples/09-testbenches/random-stimulus
```

With another seed:

```bash
cd examples/09-testbenches/random-stimulus
iverilog -g2001 -Wall -o sim.vvp sort3.v tb_sort3.v
vvp sim.vvp +seed=42
```

## Three ideas

1. **Constrained random.** Pure random bytes almost never give equal values
   (1 in 256) or the edge values 0 and 255. The `pick` function chooses
   from "small", "big", "0", "255" or "anything", with weights.
2. **Properties instead of a model.** The testbench does not sort. It checks
   that the output is ordered and that it has the same sum, minimum and
   maximum as the input.
3. **Coverage.** Counters record which situations were tested. If a case was
   never hit (for example "two values equal"), the test fails. Random tests
   without coverage can pass while testing nothing interesting.

The same seed always gives the same sequence. When a random test fails,
write down the seed: it reproduces the failure exactly.

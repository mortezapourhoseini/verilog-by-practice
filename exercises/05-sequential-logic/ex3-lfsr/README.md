# Exercise 05.3: 8-bit LFSR (pseudo-random sequence)

A **linear feedback shift register** (LFSR) is a shift register whose new
input bit is the XOR of some of its bits (the *taps*). With the right taps,
an n-bit LFSR goes through all `2^n - 1` non-zero values before it repeats.
LFSRs are used for test patterns, scramblers and cheap random numbers.

## Task

Complete `lfsr8.v`.

- On `rst`, load the seed `8'h01`.
- At every rising edge with `en = 1`:
  shift left by one, and put the feedback bit into bit 0.
- Feedback bit: `q[7] ^ q[5] ^ q[4] ^ q[3]`.

```text
q (start)       0000_0001
after 1 shift   0000_0010   (feedback = 0)
...
```

The testbench checks that the sequence:

1. matches a reference model for the first 20 steps,
2. never contains 0,
3. repeats after **exactly** 255 steps (all non-zero values appear once).

## Hints

- Use concatenation for the shift: `{q[6:0], feedback}`.
- What happens if the register ever becomes 0? Why does the seed matter?

## Run

```bash
make run DIR=exercises/05-sequential-logic/ex3-lfsr
```

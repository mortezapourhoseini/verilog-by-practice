# Exercise 12.2: fixed-point gain with rounding and saturation

Audio and DSP designs often multiply a sample by a gain. Both are **Q1.15**
numbers: 16-bit two's complement, 15 fraction bits.

```text
value = integer / 32768        range -1.0 .. +0.99997
16'h4000 =  0.5     16'hC000 = -0.5     16'h7FFF = 0.99997     16'h8000 = -1.0
```

## Task

Complete `gain_q15.v`: `y = x * g`, in Q1.15.

1. Multiply the signed values: a 32-bit product in Q2.30.
2. Round to nearest: add `2^14` (half of the last kept bit).
3. Shift right arithmetically by 15: back to Q1.15 (17 bits are enough).
4. Saturate to `[-32768, 32767]`. Only `-1.0 * -1.0 = +1.0` can overflow.

```text
x = 0.5 (4000), g = 0.5 (4000)   -> y = 0.25  (2000)
x = -1.0 (8000), g = -1.0 (8000) -> y = 0.99997 (7FFF, saturated)
x = 1 LSB (0001), g = 0.5 (4000) -> 0.5 LSB, rounds up to 1 LSB (0001)
```

## Hints

- Declare signed wires: `wire signed [31:0] prod = $signed(x) * $signed(g);`
- Use `>>>` on a **signed** value.
- Look at the output stage of `examples/12-arithmetic-blocks/mac-fixed-point`.

## Run

```bash
make run DIR=exercises/12-arithmetic-blocks/ex2-fixed-point-gain
```

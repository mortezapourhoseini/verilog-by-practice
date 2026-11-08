# Example: Gray-code counter with functions

| File | What it is |
|---|---|
| `gray_counter.v` | Counter that keeps its state in Gray code. Uses three functions. |
| `tb_gray_counter.v` | Two instances (16 and 64 states). Checks "one bit per step" and the decoded value. |

## Run

```bash
make run DIR=examples/07-parameters-generate-hierarchy/gray-counter
```

## Output (start)

```text
step 1: gray16 = 0001
step 2: gray16 = 0011
step 3: gray16 = 0010
step 4: gray16 = 0110
```

## What to look at

- `clog2` is a **constant function**: it runs at elaboration time and sets
  the width of the `gray` port from the `MODULO` parameter.
- `bin2gray` is one line. `gray2bin` needs a loop: each bit depends on the
  bit above it.
- Functions are combinational: no delays, no clock, one return value.

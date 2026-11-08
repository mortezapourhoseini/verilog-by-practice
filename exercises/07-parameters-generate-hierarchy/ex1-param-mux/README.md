# Exercise 07.1: parameterized N-to-1 multiplexer

## Task

Complete `muxn.v`. It selects one of `N` inputs, each `WIDTH` bits wide.

Verilog-2001 ports cannot be arrays, so the inputs are packed into one flat
bus: input `k` is `d[k*WIDTH +: WIDTH]`.

```text
N = 4, WIDTH = 8:
d = { d3 , d2 , d1 , d0 }
     31:24 23:16 15:8  7:0
```

| Parameter | Meaning |
|---|---|
| `WIDTH` | bits per input (default 8) |
| `N` | number of inputs (default 4) |
| `SEL_W` | width of `sel` (default 2). The user must choose `2**SEL_W >= N`. |

| Port | Width | Meaning |
|---|---|---|
| `d` | `N*WIDTH` | all inputs |
| `sel` | `SEL_W` | which input |
| `y` | `WIDTH` | `d[sel*WIDTH +: WIDTH]`, or **0 if `sel >= N`** |

## Hints

- One `assign` with an indexed part select and `? :` is enough.
- The testbench uses two instances: `WIDTH=8, N=4, SEL_W=2` and
  `WIDTH=3, N=5, SEL_W=3` (here `sel` can be 5, 6 or 7: output 0).

## Run

```bash
make run DIR=exercises/07-parameters-generate-hierarchy/ex1-param-mux
```

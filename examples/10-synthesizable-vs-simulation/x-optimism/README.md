# Example: x-optimism (one mux, three simulation results)

`a = 1111_0000`, `b = 1111_1111`, and the select is `x`:

| Style | Simulation result | Why |
|---|---|---|
| `if (sel) ... else ...` | `1111_1111` (= b) | `if (x)` is false: the x is **hidden** |
| `sel ? a : b` | `1111_xxxx` | equal bits stay, different bits become x |
| `case` with `default: y = 8'bx;` | `xxxx_xxxx` | the x stays **visible** |

All three are the **same hardware**. A real mux with an undefined select
gives an unpredictable value, so the honest answer is "x". The `if` version
tells you a nice clean number, and your test passes while the hardware fails.

## Run

```bash
make run DIR=examples/10-synthesizable-vs-simulation/x-optimism
```

## What to do about it

- Reset every control register (state, valid bits, select signals).
- Check for x in testbenches: `if (^y === 1'bx) $display("x on y!");`
- Prefer `case` with an x default or `? :` for selects that might be x.

# Example: inertial delay, transport delay and a sleeping block

```text
time (ns)    20 22        42        52
a            _/~\_________/~~~~~~~~~\________
y_inertial   ____________________/~~~~~~~~~\___     only the long pulse (47..57)
y_transport  ______/~\________________/~~~~~~~~~\__ both pulses, 5 ns later
```

| Style | Code | Short pulse (2 ns) |
|---|---|---|
| inertial | `assign #5 y = a;` | swallowed |
| transport | `always @(a) y <= #5 a;` | passes, 5 ns later |
| sleeping block | `always @(a) #5 y = a;` | missed: the block was asleep |

## Run

```bash
make run DIR=examples/11-races-and-timing/delay-types
```

All three delays are for simulation only. Synthesis ignores them, so this
folder has a `SIM_ONLY` file for `make lint`.

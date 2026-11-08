# Example: a race between two clocked blocks

Two registers that should swap at every clock edge, in two separate
`always` blocks.

| Version | Result |
|---|---|
| `<=` (non-blocking) | a and b swap at every edge |
| `=` (blocking) | after the first edge, a == b. Which value survives depends on the order in which the simulator runs the two blocks. |

## Run

```bash
make run DIR=examples/11-races-and-timing/swap-race
```

## Output

```text
after load:      non-blocking a=11 b=22   blocking a=11 b=22
after swap 1:    non-blocking a=22 b=11   blocking a=22 b=22
after swap 2:    non-blocking a=11 b=22   blocking a=22 b=22
```

The Verilog standard does not define the order of blocks that wake up at
the same event. Another simulator, or the same simulator after a small code
change, may pick the other order. Code with a race can pass all tests today
and fail tomorrow. Non-blocking assignments remove the race.

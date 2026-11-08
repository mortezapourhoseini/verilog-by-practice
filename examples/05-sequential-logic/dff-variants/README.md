# Example: four kinds of D flip-flop

| Module | Behaviour |
|---|---|
| `dff` | `q <= d` at every rising edge of `clk` |
| `dff_sync_reset` | `rst` (active high) is checked only at the clock edge |
| `dff_async_reset` | `rst_n` (active low) clears `q` at once, without a clock edge |
| `dff_enable` | `q` changes only at edges where `en` is 1 |

## Run

```bash
make run DIR=examples/05-sequential-logic/dff-variants
```

## The reset difference

```text
time (ns)  20   21   22   23   24   25   26
clk        0    0    0    0    0    1    1     (rising edge at 25)
rst/rst_n  -    -    on   on   on   on   on
q_sync     1    1    1    1    1    0    0     <- waits for the edge
q_async    1    1    0    0    0    0    0     <- clears at once
```

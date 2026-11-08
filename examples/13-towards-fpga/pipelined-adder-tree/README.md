# Example: pipelined adder tree

Sum of eight 8-bit values.

```mermaid
flowchart LR
  subgraph L1["level 1 (4 adders)"]
    a1["d0+d1"]
    a2["d2+d3"]
    a3["d4+d5"]
    a4["d6+d7"]
  end
  subgraph L2["level 2 (2 adders)"]
    b1["+"]
    b2["+"]
  end
  a1 --> b1
  a2 --> b1
  a3 --> b2
  a4 --> b2
  b1 --> c["level 3: +"]
  b2 --> c
  c --> sum
```

| Version | Registers | Adder levels per clock period | Latency |
|---|---|---|---|
| `adder_tree_comb` | output only | 3 | 1 cycle |
| `adder_tree_pipe` | after every level | 1 | 3 cycles |

## Run

```bash
make run DIR=examples/13-towards-fpga/pipelined-adder-tree
```

## What to look at

- `valid` goes through the same number of registers as the data.
- The testbench keeps a small queue of expected values and shifts it at
  every edge, like the pipeline. That is the usual way to check pipelines.
- On an FPGA, the pipelined version can run at a much higher clock
  frequency. Synthesize both with your FPGA tool and compare the timing reports.

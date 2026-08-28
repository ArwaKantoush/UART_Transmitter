# UART_TX

A parameterized, synthesizable **UART Transmitter** implemented in Verilog HDL, verified with a self-checking testbench, and taken through a complete FPGA implementation flow (elaboration → synthesis → place & route → timing analysis).

## Overview

`UART_TX` serializes an `N`-bit parallel data bus into a standard UART frame (Start bit → Data bits, LSB first → optional Parity bit → Stop bit). The design is built from four independent, reusable blocks connected through a top-level module.

```
                 ┌───────────────────┐
   P_INPUT ─────►│                   │
   V_INPUT ─────►│                   ├────► TX_OUTPUT
   CLK     ─────►│      UART_TX      │
   RST     ─────►│                   ├────► BUSY
   P_EN    ─────►│                   │
   P_BIT   ─────►│                   │
                 └───────────────────┘
```

### Ports

| Signal      | Direction | Width      | Description                                              |
|-------------|-----------|------------|------------------------------------------------------------|
| `CLK`       | input     | 1          | System clock                                                |
| `RST`       | input     | 1          | Asynchronous active-low reset                               |
| `P_INPUT`   | input     | `WIDTH`    | Parallel data bus to transmit                                |
| `V_INPUT`   | input     | 1          | Data-valid pulse — sampled for exactly 1 clock cycle          |
| `P_EN`      | input     | 1          | Parity enable (0: disabled, 1: enabled)                       |
| `P_BIT`     | input     | 1          | Parity mode when `P_EN=1` (0: even, 1: odd)                   |
| `TX_OUTPUT` | output    | 1          | Serial line output (idles high)                              |
| `BUSY`      | output    | 1          | High while a frame is being transmitted                       |

### Operational rules

- New data on `P_INPUT` is only latched while `V_INPUT` is high.
- `V_INPUT` is a single-cycle pulse; the design ignores it while `BUSY=1`.
- `TX_OUTPUT` idles high; the frame starts with a low Start bit.
- Reset is asynchronous and active-low.

## Repository structure

```
Code/
├── Constraints/
│   └── UART_TX.sdc        # Timing constraints (clock, I/O delays, false paths)
├── RTL/
│   ├── FSM.v               # Main controller (IDLE → START → DATA → PARITY → STOP)
│   ├── MUX.v                # Selects Start/Data/Parity/Stop bit onto TX_OUTPUT
│   ├── Parity_Calculator.v  # Even/Odd parity generation
│   ├── Serializer.v         # Parallel-to-serial shift register + done flag
│   └── UART_TX.v            # Top-level integration
├── Script/
│   └── run.do               # QuestaSim/ModelSim simulation script
├── Testbench/
│   └── UART_TX_tb.v         # Self-checking testbench
├── .gitignore
├── LICENSE
├── README.md
└── UART_TX.pdf              # Full project documentation (design + verification + implementation report)
```

## Architecture

The design is split into four core blocks, integrated in `UART_TX.v`:

- **FSM (Main Controller)** — drives the state machine (`IDLE`, `START`, `DATA`, `PARITY`, `STOP`), asserts `BUSY`, and generates the `SEL` control signal for the output mux and the `SER_EN` enable for the serializer.
- **Serializer** — loads `P_INPUT` on `V_INPUT`, shifts it out one bit per clock while `SER_EN` is high, and raises `SER_DONE` once the last data bit has been shifted out.
- **Parity_Calculator** — computes even/odd parity over `P_INPUT` using reduction XOR/XNOR.
- **MUX** — routes the Start bit, serial data, parity bit, or Stop/idle level onto `TX_OUTPUT` based on `SEL`.

## Simulation

Simulated with **QuestaSim/ModelSim** using a self-checking testbench that compares `TX_OUTPUT` and `BUSY` against expected values on every clock edge, covering: no-parity frames, even-parity frames, and odd-parity frames.

```tcl
vlib work
vlog Code/RTL/Parity_Calculator.v Code/RTL/Serializer.v Code/RTL/FSM.v Code/RTL/MUX.v Code/RTL/UART_TX.v Code/Testbench/UART_TX_tb.v
vsim -voptargs=+acc work.UART_TX_tb
add wave *
run -all
```

Or simply:

```sh
vsim -do Code/Script/run.do
```

## Implementation flow

The design was carried through elaboration, synthesis, and place & route, with timing constraints defined in `Code/Constraints/UART_TX.sdc` (20 ns / 50 MHz clock, asynchronous reset excluded from timing, input/output delay budgets on all ports). Full elaborated/synthesized schematics, the placed-and-routed floorplan, setup/hold timing reports, and lint results are documented in [`UART_TX.pdf`](./UART_TX.pdf).

## License

See [`LICENSE`](./LICENSE).

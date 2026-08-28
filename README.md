```markdown
# Fully Parameterized UART Transmitter (UART_TX) Subsystem

A synthesizable, parameterized **Universal Asynchronous Receiver-Transmitter (UART) Transmitter** designed and verified in **Verilog HDL**. The design converts parallel input data into a serial UART bitstream with configurable parity schemes, strict timing compliance, and robust handshaking.

---

## 📑 Table of Contents
- [Architecture Overview](#architecture-overview)
- [Key Features](#key-features)
- [FSM State Machine](#fsm-state-machine)
- [Repository Structure](#repository-structure)
- [Simulation & Verification](#simulation--verification)
- [Synthesis & Timing Constraints](#synthesis--timing-constraints)

---

## 🏛 Architecture Overview

The transmitter subsystem is partitioned into four submodules orchestrated by a centralized top-level controller:


```

```
                 +-----------------------------------+
                 |              UART_TX              |
                 |                                   |
                 |  +-----------------------------+  |

```

P_INPUT ------------>|->|      Parity Calculator      |--|----> PARITY_BIT
V_INPUT, P_EN, P_BIT |  +-----------------------------+  |          |
|                                   |          |
|  +-----------------------------+  |          v
P_INPUT ------------>|->|          Serializer         |--|----> SER_DATA ---> +-------+
V_INPUT, SER_EN ---->|->| (Shift Reg & Counter)       |--|----> SER_DONE      |       |
|  +-----------------------------+  |          |         |  MUX  |---> TX_OUTPUT
|                                   |          |         |       |
|  +-----------------------------+  |          |         +-------+
V_INPUT, P_EN ------>|->|       Main Controller       |--|----------+             ^
CLK, RST ----------->|->|            (FSM)            |--|------------------------+ (SEL[1:0])
|  +-----------------------------+  |
|          |                        |
|          v                        |
|        BUSY                       |
+-----------------------------------+

```

* **Main Controller (FSM):** Implements a 5-state Moore machine controlling state sequencing (`IDLE`, `START`, `DATA`, `PARITY`, `STOP`), busy arbitration, and mux selection.
* **Serializer:** Houses a parameterized shift-register and counter to serialize the $N$-bit parallel bus into a single-bit stream (`SER_DATA`), raising `SER_DONE` upon completion.
* **Parity Calculator:** Computes dynamic parity bits using reduction XOR/XNOR logic based on the configured parity scheme.
* **Multiplexer (MUX):** Directs the frame components (Start bit `'0'`, Serial Data, Parity bit, and Stop/IDLE line `'1'`) to `TX_OUTPUT`.

---

## ✨ Key Features

* **Parameterized Payload Width:** Default $8$-bit, scalable via the `WIDTH` parameter.
* **Configurable Parity Modes:** Supports optional parity enabled/disabled via `P_EN`, with Even (`P_BIT = 0`) or Odd (`P_BIT = 1`) schemes.
* **Asynchronous Active-Low Reset:** Dedicated `RST` to initialize internal registers and state pointers.
* **Transaction Handshaking & Busy Protection:** Samples parallel data on single-cycle `V_INPUT` pulses and raises `BUSY = 1` to prevent data overwrites during active transfers.
* **Idle State Line Stability:** Drives `TX_OUTPUT = 1` during idle periods to eliminate false start-bit triggers.

---

## 🔄 FSM State Machine


```

```
             +-------------------+
             |       IDLE        |<--------------------+
             +-------------------+                     |
                       |                               |
                       | (V_INPUT)                     |
                       v                               |
             +-------------------+                     |
             |       START       |                     |
             +-------------------+                     |
                       |                               |
                       v                               |

```

+--------------->+-------------------+ (SER_DONE & P_EN)   |
|                |       DATA        |---------------+     |
| (!SER_DONE)    +-------------------+               |     |
+----------------          |                         |     |
| (SER_DONE & !P_EN)      |     |
v                         v     |
+-------------------+          +--------+ |
|       STOP        |          | PARITY | |
+-------------------+          +--------+ |
^                         |     |
+-------------------------+     |
|                               |
+-------------------------------+

```

---

## 📁 Repository Structure

```text
├── Constraints/
│   └── UART_TX.sdc          # SDC Timing constraints (Clock, I/O delays, false paths)
├── RTL/
│   ├── FSM.v                # Finite State Machine controller
│   ├── MUX.v                # 4-to-1 Multiplexer
│   ├── Parity_Calculator.v  # Reduction XOR/XNOR Parity module
│   ├── Serializer.v         # Shift register and bit counter
│   └── UART_TX.v            # Top-level integration wrapper
├── Script/
│   └── run.do               # Automated QuestaSim / ModelSim simulation script
├── Testbench/
│   └── UART_TX_tb.v         # Self-checking Testbench
├── .gitignore               # EDA temporary artifacts filter
├── LICENSE                  # MIT License
├── README.md                # Project documentation
└── UART_TX.pdf              # Comprehensive design report & synthesis results

```

---

## 🧪 Simulation & Verification

The self-checking Testbench (`UART_TX_tb.v`) verifies:

1. **Scenario 1:** Transmission without Parity ($10$-bit UART frame: Start + 8 Data + Stop).
2. **Scenario 2:** Transmission with Even Parity ($11$-bit frame: Start + 8 Data + Even Parity + Stop).
3. **Scenario 3:** Transmission with Odd Parity ($11$-bit frame: Start + 8 Data + Odd Parity + Stop).
4. **Scenario 4:** Reset recovery and input protection during active `BUSY` state.

### Running Simulation (QuestaSim / ModelSim)

```bash
vsim -do Script/run.do

```

---

## ⏱ Synthesis & Timing Constraints

The design was constrained and analyzed using Synopsys Design Constraints (`SDC`):

* **Target Clock Period:** $20.000\text{ ns}$ ($50\text{ MHz}$)
* **Setup Slack:** $+10.390\text{ ns}$ (Timing Met)
* **Hold Slack:** $+0.445\text{ ns}$ (Timing Met)

```

```

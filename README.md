# FPGA Morse Code Display 

Morse code translator implemented on the **Intel DE10-Lite FPGA** in **Verilog HDL** — converts English letters (A–Z) to Morse code with synchronized LED blinks, mechanical-relay clicks, and 7-segment display output. Built for **EECS 3201 (Digital Logic Design)** at York University.

**[Watch the demo](https://youtube.com/shorts/Qp6rLKzYpxg)** · [Project report](./Project_Report.pdf)

## How it works

- Switches `SW[4:0]` select a letter (A=1 … Z=26), shown on HEX displays alongside its Morse pattern
- An external LED blinks the code: **dot = 0.5 s**, **dash = 1.5 s**
- A mechanical relay clicks in sync with each dot/dash for auditory feedback
- `KEY[1]`/`KEY[0]` start and reset transmission

## Module design

| Module | Role |
|---|---|
| `Project_3201MorseCode` | Top module — maps switch input to letters, drives HEX displays, coordinates transmission |
| `fsm` | Finite-state machine sequencing dot/dash LED + relay timing (0.5 s per state transition) |
| `translateMorse` | Encodes each letter as a dash/dot bit pattern + sequence length (e.g., A = `.-` → `morse=0100`, `len=1100`) |
| `clk_xx` | Clock divider — 50 MHz board clock → 0.5 s enable pulse (reset at 25,000,000 cycles) |

## External circuit

LED + relay driven through a transistor amplifier from the `Arduino_IO12` pin, providing enough current for the relay coil.

## Tech stack

`Verilog HDL` · `Intel DE10-Lite (MAX 10)` · `Quartus Prime` · `FSM design`

## Source code

```
Project_3201MorseCode.v # All modules: top (HEX display logic), fsm, clk_xx, translateMorse
Project_3201MorseCode.qsf # Quartus settings — MAX 10 (10M50DAF484C6GES) pin assignments
Project_3201MorseCode.qpf # Quartus Prime project file
```

### Build & run

1. Open `Project_3201MorseCode.qpf` in **Quartus Prime**
2. Compile (pin assignments for the DE10-Lite's MAX 10 are already in the `.qsf`)
3. Program the board via USB-Blaster
4. Set `SW[4:0]` to a letter (A=1 … Z=26), press `KEY[1]` to transmit, `KEY[0]` to stop

## Team Member
Bhavneet Kaur (218501361)
Jaideep Singh (218472241)

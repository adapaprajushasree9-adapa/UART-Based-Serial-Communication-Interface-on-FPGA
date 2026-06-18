# UART-Based Serial Communication Interface on FPGA

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) based serial communication interface on the Basys 3 FPGA using Verilog HDL. The design enables reliable serial data exchange between a PC and FPGA through a USB-UART connection.

The system receives serial data from a terminal application, reconstructs the transmitted byte, displays the received data on onboard LEDs, and echoes the same data back to the sender. The receiver employs 16× oversampling to improve sampling accuracy and robustness during data reception.

---

## Key Features

- UART Receiver (RX) implementation
- UART Transmitter (TX) implementation
- UART Echo functionality
- 9600 baud communication
- 16× oversampling receiver
- LED display of received data
- Finite State Machine (FSM) based design
- FPGA implementation on Basys 3
- Real-time serial communication with PC terminal

---

## System Specifications

| Parameter | Value |
|------------|---------|
| FPGA Board | Basys 3 |
| FPGA Device | Xilinx Artix-7 |
| System Clock | 100 MHz |
| Baud Rate | 9600 bps |
| Data Bits | 8 |
| Parity | None |
| Stop Bits | 1 |
| Oversampling Rate | 16× |

---

## System Architecture

```text
                    +------------------+
                    | Baud Generator   |
                    +--------+---------+
                             |
                  +----------+----------+
                  |                     |
               tx_en                rx_en
                  |                     |
                  v                     v

          +---------------+     +---------------+
          | UART TX       |     | UART RX       |
          | Transmitter   |     | Receiver      |
          +-------+-------+     +-------+-------+
                  ^                     |
                  |                     |
                  |                 rx_data
                  |                 rx_done
                  |                     |
                  +----------+----------+
                             |
                             v
                      Echo Controller
                             |
                             v
                            LEDs
```

---

## Design Modules

### Baud Generator

The baud generator derives UART timing signals from the 100 MHz FPGA clock.

**Functions:**
- Generates transmit enable pulse (`tx_en`) for 9600 baud transmission.
- Generates receive enable pulse (`rx_en`) for 16× oversampling during reception.

---

### UART Transmitter

The transmitter converts parallel data into serial format and sends it through the UART TX line.

#### FSM States

```text
IDLE → START → DATA → STOP → IDLE
```

#### Frame Format

```text
Start Bit : 0
Data Bits : 8
Parity    : None
Stop Bit  : 1
```

#### Operation

1. Waits for `tx_start`.
2. Loads the input byte.
3. Transmits the start bit.
4. Sends 8 data bits (LSB first).
5. Transmits the stop bit.
6. Generates `tx_done` after successful transmission.

---

### UART Receiver

The receiver reconstructs serial data received through the UART RX line.

#### FSM States

```text
IDLE → START → DATA → STOP → IDLE
```

#### Operation

1. Detects the falling edge of the start bit.
2. Verifies the start bit using midpoint sampling.
3. Samples incoming data using 16× oversampling.
4. Stores received bits into a data register.
5. Verifies the stop bit.
6. Transfers the received byte to `rx_data`.
7. Generates `rx_done` upon successful reception.

---

### Top-Level Echo Controller

The top module integrates all UART subsystems.

**Functions:**
- Receives incoming UART data.
- Displays received data on LEDs.
- Automatically transmits the received byte back to the sender.
- Generates a one-clock-cycle transmit start pulse.

---

## UART Echo Operation

```text
PC Terminal
     |
     |  Serial Data
     v

+----------------+
|  Basys 3 FPGA  |
+----------------+
     |
     |--> UART Receiver
     |
     |--> LED Display
     |
     |--> UART Transmitter
     |
     v

Echoed Data Back To Terminal
```

---

## Hardware Validation

The design was synthesized, implemented, and programmed onto the Basys 3 FPGA board.

### Testing Procedure

1. Connect the Basys 3 FPGA to the PC via USB.
2. Open a serial terminal application (PuTTY).
3. Select the appropriate COM port.
4. Configure UART settings:
   - Baud Rate: 9600
   - Data Bits: 8
   - Parity: None
   - Stop Bits: 1
5. Type characters in the terminal.
6. Verify:
   - Characters are echoed back correctly.
   - LEDs display the received ASCII value.

---

## Project Files

```text
baud_generator.v
uart_tx.v
uart_rx.v
uart_echo_top.v
```

---

## Simulation and Verification

The design was verified through simulation to validate:

- Baud generation
- Start bit detection
- Data reception
- Data transmission
- Stop bit validation
- UART echo functionality

Waveform analysis was performed to confirm correct UART frame generation and reception.

---

## Learning Outcomes

- UART protocol implementation
- Serial communication principles
- Finite State Machine (FSM) design
- Baud rate generation techniques
- UART oversampling methodology
- FPGA-based hardware verification
- Verilog HDL based digital design

---

## Tools Used

- Vivado
- Icarus Verilog (iverilog)
- GTKWave
- PuTTY
- Basys 3 FPGA Board

---

## Future Improvements

- Configurable baud rate selection
- UART FIFO buffering
- Parity bit generation and checking
- Framing error detection
- Interrupt-driven communication
- Full-duplex communication extensions

---

## Author

**Sree**  
B.Tech, Electronics and Communication Engineering  
Indian Institute of Technology Bhubaneswar

This project demonstrates the complete implementation of a UART-based serial communication interface on FPGA, including serial data reception, transmission, baud rate generation, and real-time echo functionality.

# UART Echo System on Basys 3 FPGA

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Echo System on the Basys 3 FPGA using Verilog HDL. The design receives serial data from a PC through UART, displays the received byte on the onboard LEDs, and immediately transmits the same byte back to the sender.

The system consists of a Baud Rate Generator, UART Receiver, UART Transmitter, and a Top-Level Echo Controller. The design was verified through simulation and validated on FPGA hardware using a USB-UART connection and a serial terminal.

---

## Features

- UART Receiver (RX) implementation
- UART Transmitter (TX) implementation
- UART Echo functionality
- Baud rate generation from 100 MHz system clock
- 16× oversampling in receiver for reliable data sampling
- Received data displayed on onboard LEDs
- FPGA implementation on Basys 3
- Real-time serial communication with PC terminal
- FSM-based UART design

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
                 UART Echo Logic
                         |
                         v
                       LEDs
```

---

## Module Description

### 1. Baud Generator

Generates enable pulses required for UART transmission and reception.

#### Functionality

- Uses the 100 MHz Basys 3 clock as input.
- Generates transmit enable pulse (`tx_en`).
- Generates receive enable pulse (`rx_en`) for 16× oversampling.

#### Counter Values

| Signal | Counter Value | Purpose |
|---------|--------------|----------|
| tx_en | 10416 | UART transmit baud tick |
| rx_en | 650 | 16× oversampling tick |

---

### 2. UART Transmitter

Implements UART serial data transmission using a finite state machine.

#### FSM States

```text
IDLE → START → DATA → STOP → IDLE
```

#### Transmission Format

- Start Bit : 0
- Data Bits : 8
- Parity : None
- Stop Bit : 1

#### Operation

1. Waits for `tx_start`.
2. Loads parallel data into a shift register.
3. Sends start bit.
4. Transmits 8 data bits (LSB first).
5. Sends stop bit.
6. Asserts `tx_done` after successful transmission.

---

### 3. UART Receiver

Receives serial UART data and reconstructs the original byte.

#### FSM States

```text
IDLE → START → DATA → STOP → IDLE
```

#### Reception Method

- Detects start bit.
- Uses 16× oversampling.
- Samples the start bit at its midpoint.
- Samples each data bit after 16 oversampling ticks.
- Stores received bits into a data register.
- Verifies stop bit.
- Generates `rx_done` when reception completes.

---

### 4. UART Echo Top Module

Integrates the baud generator, UART receiver, and UART transmitter.

#### Functionality

- Receives UART data from PC.
- Displays received byte on LEDs.
- Sends the received byte back through UART.
- Generates a one-clock-cycle transmit start pulse.

#### Echo Operation

```text
PC -----> FPGA

Receive Byte
      |
Display on LEDs
      |
Transmit Same Byte
      |
FPGA -----> PC
```

---

## UART Configuration

| Parameter | Value |
|------------|---------|
| Clock Frequency | 100 MHz |
| Baud Rate | 9600 bps |
| Data Bits | 8 |
| Parity | None |
| Stop Bits | 1 |
| Oversampling | 16× |

---

## Hardware Used

- Basys 3 FPGA Board
- Xilinx Artix-7 FPGA
- USB-UART Interface
- PC Serial Terminal (PuTTY)

---

## Verification

### Simulation

The design was simulated to verify:

- Start bit detection
- Data reception
- Data transmission
- Stop bit validation
- UART echo functionality

### FPGA Testing

The design was programmed onto the Basys 3 FPGA and tested using a serial terminal.

#### Test Procedure

1. Connect Basys 3 to the PC using USB.
2. Open PuTTY.
3. Select the appropriate COM port.
4. Configure UART settings:
   - Baud Rate: 9600
   - Data Bits: 8
   - Parity: None
   - Stop Bits: 1
5. Type characters in the terminal.
6. Observe:
   - Characters echoed back to the terminal.
   - Corresponding ASCII value displayed on LEDs.

---

## Project Files

```text
baud_generator.v
uart_tx.v
uart_rx.v
uart_echo_top.v
```

---

## Learning Outcomes

- UART protocol implementation
- FSM-based digital design
- Serial communication concepts
- Baud rate generation
- Oversampling techniques in UART receivers
- FPGA hardware validation
- Verilog HDL design methodology

---

## Future Enhancements

- Configurable baud rates
- UART FIFO buffers
- Parity generation and checking
- Framing error detection
- Interrupt-driven communication
- Full-duplex UART communication framework

---

## Tools Used

- Vivado
- Icarus Verilog (iverilog)
- GTKWave
- PuTTY
- Basys 3 FPGA Board

---

## Author

**Sree**  
B.Tech, Electronics and Communication Engineering  
Indian Institute of Technology Bhubaneswar

This project demonstrates the implementation of a UART communication system in Verilog HDL, including serial reception, transmission, and real-time echo functionality on FPGA hardware.

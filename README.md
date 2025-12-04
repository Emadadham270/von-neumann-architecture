5-Stage Pipelined Processor – README
Overview
  


This project implements a simple 5-stage pipelined Von Neumann processor with a unified memory for instructions and data.
The processor supports a RISC-like ISA, eight 32-bit general-purpose registers, stack operations, interrupt handling, and full pipelined execution.

This project was completed as part of CMP3010 – Computer Architecture, Faculty of Engineering, Cairo University.

Features
 5-Stage Pipeline

IF – Instruction Fetch

ID – Instruction Decode

EX – Execute

MEM – Memory Access

WB – Write Back

✔ ISA Support

Includes all required instruction types:

One-operand (INC, NOT, SETC, OUT, IN, etc.)

Two-operand (ADD, SUB, AND, MOV, SWAP, IADD)

Memory operations (LDM, LDD, STD, PUSH, POP)

Branching & control (JZ, JN, JC, JMP, CALL, RET, INT, RTI)
All instruction behaviors follow the ISA specification precisely.

✔ Interrupt Handling

Finishes all in-pipeline instructions before servicing the interrupt

Pushes PC and flags on stack

Jumps to interrupt vector stored at memory location M[1]

RTI restores execution flow

✔ Condition Code Register (CCR)

Supports flags:

Z – Zero

N – Negative

C – Carry
Flags update according to arithmetic/logic rules.

Architecture Components
Registers

R0–R7: General purpose 32-bit registers

PC: Program counter

SP: Stack pointer (initialized to 2²⁰ − 1)

CCR: Condition code register (Z, N, C)

Memory

1 MB unified memory, 32-bit word-addressable

Used for both instructions and data

ALU

Supports:

ADD, SUB, AND, NOT

Shift operations (if used by your team)

Updates CCR flags

Pipeline Design
Pipeline Registers

Each stage has a separate register carrying:

Instruction opcode

Operands (Rsrc, Rdst, immediate, offset)

Flags

Control signals

Forwarded values

Hazard Handling
✔ Data Hazards

Solved using data forwarding paths from:

EX/MEM → ID/EX

MEM/WB → ID/EX

✔ Structural Hazards

Avoided by ensuring separate IR and data memory access logic

✔ Control Hazards

Solved using Static Branch Prediction (Always Not Taken)

Flush pipeline on taken branch

Assembler

A Python/VHDL-based assembler converts:

Assembly (.asm) → Machine code (.mem)
The assembler maps each instruction format to opcode and binary encoding based on project rules.

Simulation
Your simulation includes:

DO-files for automated waveform setup

Memory loading using the generated .mem file

Monitoring of main signals:
R0–R7, PC, SP, FLAGS, CLK, RESET, INTERRUPT, IN.PORT, OUT.PORT

Simulation shows:

Pipeline behavior

Correct branching

Hazard resolution

Interrupt handling

Project Deliverables
Phase 1

✔ Instruction format & opcode table
✔ Data path diagram
✔ Control unit design
✔ Pipeline stages & registers
✔ Hazard analysis with solutions

Phase 2

✔ Full processor VHDL implementation
✔ Integrated top-level architecture
✔ Assembler implementation
✔ Simulation testbench & waveforms
✔ Final report (design changes + hazard analysis)
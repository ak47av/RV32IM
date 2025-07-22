# RV32IM on AMD Vivado

Vivado by AMD is a comprehensive set of design tools for digital design for FPGAs supported by the Vivado ecosystem.

## Description of how the core works

- The **InstructionMemory** block contains the instructions that will be executed in the datapath
    - The InstructionMemory block is instantiated as a combinational case block and not using a dedicated memory block so that the design does not depend on proprietary AMD/Xilinx IP and can be synthesized on most FPGA toolchains open source or otherwise
    - To program the core, the *InstructionMemory.sv* must be modified. The *insGenerator.py* python file generates the *InstructionMemory.sv* file from the instructions provided in the *ins.txt* file
    - Assemble the instructions using the Venus 
- The **ControlLogic** block is also instantiated in a similar way. **THIS FILE MUST NOT BE MODIFIED**
    - The Spreadsheets used for designing the Control logic are made available in the *ControlLogic* folder
- The **ImmediateGenerator** decodes the immediate values necessary for instructions that require immediate values
- The **ProgramCounter** block increments the program counter to point to successive instructions once the current instruction completes execution
- The **ALU** block implements the arithmetic instructions as well as the M-extension - Multiplication and division
    - The arithemtic instructions are performed in a single clock cycle
- The **Radix4Booth** block implements Radix-4 Booth multiplication and performs multiplication in 16 clock cycles (18 including setup and close stages)
- The **Radix2SRT** block implements Radix-2 SRT Division and performs division in 32 clock cycles (34 including setup and close stages)
- The **RegisterFile** contains the registers of the core and can be written to by using the arithmetic instructions

## Instructions supported
- All arithmetic instructions
    - add, addi
    - sub
    - or, ori
    - and, andi
    - sll, slli
    - srl, srli
    - sra, srai
    - sltu, slti, sltiu
    - xor, xori
- Multiplication
    - MUL (lower 32 bits)
    - MULH (upper 32 bits signed*signed)
    - MULHU (upper 32 bits unsigned*unsigned)
    - MULHSU (upper 32 bits signed*unsigned)
- Division
    - DIV (signed/signed division)
    - DIVU (unsigned/unsigned division)
    - REM (signed/signed remainder)
    - REMU (unsigned/unsigned remainder)

## What is not supported from RV32I
If these instructions are placed in the instruction memory, the core performs a NOP (addi x0, x0, 0)
- Load and store instructions
- Branch instructions

## Setup

### Install AMD Vivado

- Install your preferred version of Vivado from [here](https://www.xilinx.com/support/download.html) based on your CPU architecture and OS
- You will have to sign up for a license for Vivado since it is proprietary software
- Vivado 2024.2 was used on Windows 11 on x86 for this project

### Clone the repository

- Clone [this](https://github.com/ak47av/RV32IM) git repository to your local machine

### Description of project files

- The project is made of folders corresponding to each separate block of the CPU
- This is done so that the Systemverilog HDL could also be used with other synthesis tools that support Systemverilog
- A full AMD Vivado project is included as well in the *RV32IM Vivado* folder

### To run the simulation
- Open this project in Vivado by going to File->Project->Open
- Select *RV32IM_Vivado.xpr* within the *RV32IM_Vivado* folder- Once the project is opened
- Click on the Simulation Sources dropdown in the Sources view
- Right click on Datapath_tb and select "Set as top"
- Run the simulation by clicking the Run Simulation option on the Flow navigator on the left
- The output of the simulation for 32 instructions (which is how many instructions the instruction memory block holds in this design) should be visible on the Tcl Console 






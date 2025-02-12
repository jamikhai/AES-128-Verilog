# AES-128 in Verilog

This repository contains an FPGA implementation of the AES-128 encryption algorithm in Verilog. The project is designed to showcase various modular hardware designs for a widely used cryptographic standard.

## Motivation

AES-128 is a cornerstone of modern cryptography, used in securing data and communications. Through this project, I am able to explore simple, pipelined, and multi-pipelined architectures for encryption in Verilog to compare power, performance, area, and timing of each design. Architectures are planned using block diagrams, and Vivado projects are generated for each design using a Tcl script for easy code reuse and version control.

## Algorithm Information

- **AES on Wikipedia:**  
  [https://en.wikipedia.org/wiki/Advanced_Encryption_Standard](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)

- **NIST FIPS 197 (AES Specification including test vectors):**  
  [https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf)

- **AES Explained (Advanced Encryption Standard) - Computerphile:**  
  [Easy to understand video from a great YouTube channel](https://www.youtube.com/watch?v=O4xNJsjtN6E)

## Structure
Note: Project created with Vivado 2024.1

- `design/`: block diagrams of proposed architectures (open in draw.io)  
- `<project>/src`: Verilog modules containing alogorithm logic
- `<project>/sim`: Verilog testbenchs for the source modules


## Getting Started

1. **Clone the Repository**  

2. **Project Generation:**  
   Use the provided TCL script to create a Vivado project that includes the `src/` and `sim/` directories.  
   `vivado -mode tcl -source generateProject.tcl -tclargs <project_name>`

   e.g.
   `vivado -mode tcl -source generateProject.tcl -tclargs AES-Simple`

3. **Comparison:**  
   Run simulation, synthesis, and implementation to compare designs.




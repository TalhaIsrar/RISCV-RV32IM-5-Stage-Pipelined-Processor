# RV32IM 5-Stage Pipelined Processor

This repository contains the implementation and verification of a RISC-V RV32IM processor with a classic 5-stage pipeline.  
The design supports the base **RV32I** instruction set along with **M-extension** (multiplication and division). It also has a hazard unit for flushing/stalling the pipeline, a forwarding unit to prevent data hazards and a branch target buffer for branch prediction 

## 📂 Repository Structure

- **src/**  
  Contains RTL source files for the processor (written in Verilog/SystemVerilog).  
  Includes pipeline stages, forwarding unit, hazard detection, control logic, and ALU.  

- **tb/**  
  Testbenches for simulation and verification.  

- **programs/**  
  Sample RISC-V assembly/C programs compiled to run on the processor.  
  Used for functional testing (e.g., arithmetic ops, loops, memory tests).  

- **LICENSE**  
  License information for using this project.  

- **README.md**  
  Main documentation file (this one).  

## 🚀 Features

- 5-Stage pipeline: IF, ID, EX, MEM, WB  
- Hazard detection and forwarding unit  
- Branch target buffer (BTB) for branch prediction  
- Support for RV32I + M-extension (mul/div)  
- Modular design for easy extension  

## 🛠️ Tools Used

- **Vivado + ModelSim** (simulation and synthesis)  
- **RISC-V GCC toolchain** (for assembling test programs)  

## 📜 How to Run

1. Clone the repo  
   ```bash
   git clone https://github.com/TalhaIsrar/RISCV-RV32IM-5-Stage-Pipelined-Processor
   ```

2. Open **ModelSim** or **Vivado** project and add RTL files from `src/` and testbench files from `tb/`.

3. Run provided test programs from `programs/`.

## 📌 Future Work

* Support for CSR instructions
* Improved branch predictor
* Integration with memory-mapped I/O peripherals
* UVM-based verification environment

---

## 🔗 References

* [RISC-V ISA Manual](https://riscv.org/technical/specifications/)
* \[Computer Organization and Design RISC-V Edition – Patterson & Hennessy]

---

## 📄 License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributions

Contributions, suggestions, and issue reports are welcome! Feel free to fork and open pull requests.

---

*Created by Talha Israr*  

# RISC-V Assembly Programs for 5-Stage Pipeline Processor

This directory contains assembly programs and test cases for the **RV32IM 5-stage pipeline processor** implemented in Verilog/VHDL. The programs are compiled into machine code (`.hex`) that can be loaded into the instruction memory of the processor during simulation or FPGA synthesis.

---

## Directory Structure

```

programs/
│── instructions.s       # Main test assembly file
│── instructions.hex     # Generated hex file for instruction memory
│── Makefile             # Build automation (assemble, link, hex conversion)
│
└── tests/               # Additional test programs
    │── alu_edgecases.s
    │── btb_test.s
    │── consecutive_m_test.s
    │── forwarding_test.s
    │── instructions_final.s
    │── instructions_hazard_forwarding_without_btb.s
    │── instructions_hazard_forwarding_with_btb.s
    │── instructions_without forwarding.s
    │── load_store_test.s
    │── stress_test_errors.s

````

---

## RISC-V Toolchain Setup (Linux/WSL)

You need the RISC-V GNU toolchain installed to build the programs. On Ubuntu/WSL:

```bash
sudo apt update
sudo apt install gcc-riscv64-unknown-elf
sudo apt install binutils-riscv64-unknown-elf
````

This provides the cross-compiler (`riscv64-unknown-elf-gcc`) and utilities (`objcopy`, `objdump`).

---

## Build Instructions

From the `programs/` directory:

```bash
# Assemble and build everything (ELF, BIN, HEX, disassembly)
make

# Clean generated files
make clean
```

---

## Output Files

* **`instructions.elf`** → Executable and Linkable Format output
* **`instructions.bin`** → Raw binary
* **`instructions.hex`** → Hex file (one instruction per line, 32-bit little-endian) for loading into the processor’s instruction memory
* **`program.dump`** → Disassembly for debugging/reference

---

## Makefile Explanation

The `Makefile` automates the process of turning RISC-V assembly into a usable `.hex` file.

### Variables

* `RISCV_PREFIX = riscv64-unknown-elf` → Prefix for the RISC-V cross toolchain.
* `CC = $(RISCV_PREFIX)-gcc` → Assembler/compiler.
* `OBJCOPY = $(RISCV_PREFIX)-objcopy` → Converts between object file formats.
* `OBJDUMP = $(RISCV_PREFIX)-objdump` → Produces disassembly.
* `SRC`, `ELF`, `BIN`, `HEX` → Filenames for source and generated outputs.

### Build Rules

1. **ELF generation**

   ```make
   $(CC) -march=rv32im -mabi=ilp32 -nostdlib -Ttext=0x0 -o instructions.elf instructions.s
   ```

   * Compiles `instructions.s` into `instructions.elf`.
   * `-march=rv32im` → Target ISA = RV32IM.
   * `-mabi=ilp32` → Integer ABI (32-bit).
   * `-nostdlib` → Don’t link against C standard libraries.
   * `-Ttext=0x0` → Place code starting at address `0x0`.

2. **Binary conversion**

   ```make
   $(OBJCOPY) -O binary instructions.elf instructions.bin
   ```

   * Strips ELF headers → produces raw machine code.

3. **Hex conversion**

   ```make
   xxd -p -c4 instructions.bin | tac | \
   awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' | tac > instructions.hex
   ```

   * Converts binary into human-readable hex.
   * Ensures little-endian 32-bit word ordering (RISC-V format).
   * One instruction per line → directly loadable into instruction memory.

4. **Disassembly**

   ```make
   $(OBJDUMP) -d --no-show-raw-insn instructions.elf > program.dump
   ```

   * Creates an annotated disassembly for debugging.

5. **Clean**

   ```make
   rm -f instructions.elf instructions.bin instructions.hex program.dump
   ```

   * Removes all generated files.

---

## Running Tests

To test other programs from the `tests/` folder:

1. Copy or rename the desired test file into `programs/instructions.s`

   ```bash
   cp tests/alu_edgecases.s instructions.s
   ```
2. Rebuild:

   ```bash
   make clean
   make
   ```
3. Use the generated `instructions.hex` as your processor’s instruction memory.

---

## 📄 License

This project is released under the MIT License.

---

## 🤝 Contributions

Contributions, suggestions, and issue reports are welcome! Feel free to fork and open pull requests.

---

*Created by Talha Israr*  
# Toolchain prefix
RISCV_PREFIX = riscv64-unknown-elf

# Tools
CC      = $(RISCV_PREFIX)-gcc
OBJCOPY = $(RISCV_PREFIX)-objcopy
OBJDUMP = $(RISCV_PREFIX)-objdump

# Source and output files
SRC     = instructions.s
ELF     = instructions.elf
BIN     = instructions.bin
HEX     = instructions.hex

# Default target: assemble, create binary, convert to hex, and dump disassembly
all: $(HEX) dump

# Compile assembly to ELF (RV32I, no standard libs, start at 0x0)
$(ELF): $(SRC)
	$(CC) -march=rv32im -mabi=ilp32 -nostdlib -Ttext=0x0 -o $@ $<

# Convert ELF to raw binary
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

# Convert binary to hex file (one 32-bit instruction per line)
$(HEX): $(BIN)
	xxd -p -c4 $(BIN) | tac | awk '{print substr($$0,7,2) substr($$0,5,2) substr($$0,3,2) substr($$0,1,2)}' | tac > $@

# Generate disassembly dump for reference
dump: $(ELF)
	$(OBJDUMP) -d --no-show-raw-insn $< > program.dump
	@echo "Disassembly saved to program.dump"

# Clean build files
clean:
	rm -f $(ELF) $(BIN) $(HEX) program.dump

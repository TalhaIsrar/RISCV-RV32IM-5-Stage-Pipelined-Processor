# Toolchain prefix
RISCV_PREFIX = riscv64-unknown-elf

# Compiler & binutils
CC      = $(RISCV_PREFIX)-gcc
OBJCOPY = $(RISCV_PREFIX)-objcopy
OBJDUMP = $(RISCV_PREFIX)-objdump

# Files
SRC     = instructions.s
ELF     = instructions.elf
BIN     = instructions.bin
HEX     = instructions.hex

# Default target
all: $(BIN) $(HEX) dump

# Assemble & link (no stdlib, start at address 0x0)
$(ELF): $(SRC)
	$(CC) -nostdlib -Ttext=0x0 -o $@ $<

# Convert ELF to raw binary
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $(ELF) $(BIN)

# Convert binary to hex
$(HEX): $(BIN)
	hexdump -v -e '1/4 "%08x\n"' $(BIN) > $(HEX)

# Show disassembly
dump: $(ELF)
	$(OBJDUMP) -d $(ELF) > program.dump
	@echo "Assembly dump saved to program.dump"

# Clean build files
clean:
	rm -f $(ELF) $(BIN) $(HEX) program.dump

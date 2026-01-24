# RISC-V CPU Project Makefile
# ============================

# Tool configuration
IVERILOG = iverilog
VVP = vvp
VERILATOR = verilator
GTKWAVE = gtkwave

# RISC-V toolchain
RISCV_PREFIX = riscv32-unknown-elf-
CC = $(RISCV_PREFIX)gcc
AS = $(RISCV_PREFIX)as
LD = $(RISCV_PREFIX)ld
OBJDUMP = $(RISCV_PREFIX)objdump
OBJCOPY = $(RISCV_PREFIX)objcopy

# Directories
SRC_DIR = src
SIM_DIR = sim
OUTPUT_DIR = $(SRC_DIR)/output
SRAM_DIR = $(SIM_DIR)/SRAM

# Test program (default: prog0)
PROG ?= prog0
PROG_DIR = $(SIM_DIR)/$(PROG)

# Single module test (for unit testing individual RTL modules)
MODULE ?=
TB_DIR = $(SIM_DIR)/tb
MODULE_TB = $(TB_DIR)/$(MODULE)_tb.sv
MODULE_OUT = $(OUTPUT_DIR)/$(MODULE)_tb.out
MODULE_WAVE = $(OUTPUT_DIR)/$(MODULE)_wave.vcd

# Source files
TOP_TB = $(SRC_DIR)/top_tb.sv
TOP = $(SRC_DIR)/top.sv
SRAM_WRAPPER = $(SRC_DIR)/SRAM_wrapper.sv
SRAM_RTL = $(SRAM_DIR)/SRAM_rtl.sv

# All SystemVerilog source files
SV_SRCS = $(TOP_TB) $(TOP) $(SRAM_WRAPPER) $(SRAM_RTL)

# Output files
SIM_OUT = $(OUTPUT_DIR)/top_tb.out
WAVE_FILE = $(OUTPUT_DIR)/wave.vcd
RESULT_FILE = $(PROG_DIR)/result_rtl.txt

# Iverilog flags
IVERILOG_FLAGS = -g2012 -o $(SIM_OUT)

# VVP flags
VVP_FLAGS =

# Default target
.PHONY: all
all: sim

# Create output directory
$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

# Compile with iverilog
.PHONY: compile
compile: $(OUTPUT_DIR)
	cd $(PROG_DIR) && $(IVERILOG) $(IVERILOG_FLAGS) \
		-I../../$(SRC_DIR) \
		-I../../$(SRAM_DIR) \
		../../$(TOP_TB)

# Run simulation
.PHONY: sim
sim: compile
	cd $(PROG_DIR) && $(VVP) $(VVP_FLAGS) ../../$(SIM_OUT)

# Run simulation with waveform dump
.PHONY: sim_wave
sim_wave: compile
	cd $(PROG_DIR) && $(VVP) $(VVP_FLAGS) ../../$(SIM_OUT) +fsdb+autoflush +dump_vcd

# View waveform
.PHONY: wave
wave:
	$(GTKWAVE) $(WAVE_FILE) &

# Verilator lint check
.PHONY: lint
lint:
	$(VERILATOR) --lint-only -Wall \
		--top-module top \
		-I$(SRC_DIR) \
		-I$(SRAM_DIR) \
		$(TOP) $(SRAM_WRAPPER) $(SRAM_RTL)

# ============================
# Single Module Testing
# ============================

# Create testbench directory
$(TB_DIR):
	mkdir -p $(TB_DIR)

# Check MODULE is specified
.PHONY: check_module
check_module:
ifndef MODULE
	$(error MODULE is not set. Usage: make sim_module MODULE=<module_name>)
endif
	@if [ ! -f "$(MODULE_TB)" ]; then \
		echo "Error: Testbench $(MODULE_TB) not found"; \
		echo "Please create $(MODULE_TB) first"; \
		exit 1; \
	fi

# Compile single module testbench
.PHONY: compile_module
compile_module: check_module $(OUTPUT_DIR)
	$(IVERILOG) -g2012 -o $(MODULE_OUT) \
		-I$(SRC_DIR) \
		-I$(SRAM_DIR) \
		$(MODULE_TB)

# Run single module simulation
.PHONY: sim_module
sim_module: compile_module
	$(VVP) $(VVP_FLAGS) $(MODULE_OUT)

# Run single module simulation with waveform
.PHONY: sim_module_wave
sim_module_wave: compile_module
	$(VVP) $(VVP_FLAGS) $(MODULE_OUT) +dump_vcd

# View module waveform
.PHONY: wave_module
wave_module:
	$(GTKWAVE) $(MODULE_WAVE) &

# Lint single module
.PHONY: lint_module
lint_module: check_module
	$(VERILATOR) --lint-only -Wall \
		--top-module $(MODULE) \
		-I$(SRC_DIR) \
		-I$(SRAM_DIR) \
		$(SRC_DIR)/rtl/$(MODULE).sv

# List available modules
.PHONY: list_modules
list_modules:
	@echo "Available RTL modules in $(SRC_DIR):"
	@ls -1 $(SRC_DIR)/*.sv 2>/dev/null | xargs -I{} basename {} .sv | grep -v _tb || true
	@echo ""
	@echo "Available testbenches in $(TB_DIR):"
	@ls -1 $(TB_DIR)/*_tb.sv 2>/dev/null | xargs -I{} basename {} _tb.sv || echo "  (none)"

# ============================
# RISC-V Assembly Compilation
# ============================

# Assembly flags
ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = -T $(PROG_DIR)/link.ld -nostdlib

# Compile assembly to object
$(PROG_DIR)/%.o: $(PROG_DIR)/%.S
	$(AS) $(ASFLAGS) -o $@ $<

# Link objects
$(PROG_DIR)/main.elf: $(PROG_DIR)/setup.o $(PROG_DIR)/main.o
	$(LD) $(LDFLAGS) -o $@ $^

# Generate hex files (split into 4 byte lanes)
.PHONY: hex
hex: $(PROG_DIR)/main.elf
	$(OBJCOPY) -O verilog --verilog-data-width=1 -j .text $< $(PROG_DIR)/main_text.hex
	$(OBJCOPY) -O verilog --verilog-data-width=1 -j .data $< $(PROG_DIR)/main_data.hex

# Generate disassembly
.PHONY: dump
dump: $(PROG_DIR)/main.elf
	$(OBJDUMP) -d $< > $(PROG_DIR)/main.dump

# ============================
# Utility targets
# ============================

# Run all tests
.PHONY: test
test: sim
	@echo "=== Test Results ==="
	@cat $(RESULT_FILE)

# Clean simulation outputs
.PHONY: clean
clean:
	rm -f $(OUTPUT_DIR)/*.out
	rm -f $(OUTPUT_DIR)/*.vcd
	rm -f $(PROG_DIR)/*.log
	rm -f $(PROG_DIR)/result_rtl.txt

# Clean all generated files
.PHONY: cleanall
cleanall: clean
	rm -f $(PROG_DIR)/*.o
	rm -f $(PROG_DIR)/*.elf
	rm -f $(PROG_DIR)/*.dump

# Help
.PHONY: help
help:
	@echo "RISC-V CPU Project Makefile"
	@echo "============================"
	@echo ""
	@echo "Usage: make [target] [PROG=prog_name] [MODULE=module_name]"
	@echo ""
	@echo "Simulation targets:"
	@echo "  compile    - Compile SystemVerilog files with iverilog"
	@echo "  sim        - Run simulation (default)"
	@echo "  sim_wave   - Run simulation with waveform dump"
	@echo "  wave       - Open waveform viewer (gtkwave)"
	@echo "  lint       - Run Verilator lint check"
	@echo ""
	@echo "Single module testing:"
	@echo "  sim_module      - Run single module testbench (requires MODULE=<name>)"
	@echo "  sim_module_wave - Run single module testbench with waveform"
	@echo "  wave_module     - View single module waveform"
	@echo "  lint_module     - Lint check single module"
	@echo "  list_modules    - List available modules and testbenches"
	@echo ""
	@echo "Assembly targets:"
	@echo "  hex        - Generate hex files from assembly"
	@echo "  dump       - Generate disassembly"
	@echo ""
	@echo "Utility targets:"
	@echo "  test       - Run simulation and show results"
	@echo "  clean      - Remove simulation outputs"
	@echo "  cleanall   - Remove all generated files"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  PROG       - Test program directory (default: prog0)"
	@echo "  MODULE     - Module name for single module testing"
	@echo ""
	@echo "Examples:"
	@echo "  make sim                        - Run simulation with prog0"
	@echo "  make sim PROG=prog1             - Run simulation with prog1"
	@echo "  make sim_wave                   - Run with waveform dump"
	@echo "  make sim_module MODULE=alu      - Test ALU module (needs sim/tb/alu_tb.sv)"
	@echo "  make lint_module MODULE=regfile - Lint check regfile module"

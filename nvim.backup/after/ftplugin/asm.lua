-- ============================================================================
-- RISC-V Assembly File Type Settings
-- ============================================================================

-- Buffer local settings
vim.opt_local.commentstring = "# %s"
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 100

-- RISC-V syntax highlighting
vim.cmd([[
  " =========================================
  " RV32I Base Instructions
  " =========================================

  " R-type instructions
  syntax keyword riscvInstruction add sub sll slt sltu xor srl sra or and

  " I-type instructions (arithmetic)
  syntax keyword riscvInstruction addi slti sltiu xori ori andi slli srli srai

  " Load instructions
  syntax keyword riscvInstruction lb lh lw lbu lhu

  " Store instructions
  syntax keyword riscvInstruction sb sh sw

  " Branch instructions
  syntax keyword riscvInstruction beq bne blt bge bltu bgeu

  " Jump instructions
  syntax keyword riscvInstruction jal jalr

  " Upper immediate instructions
  syntax keyword riscvInstruction lui auipc

  " System instructions
  syntax keyword riscvInstruction ecall ebreak fence

  " =========================================
  " Pseudo Instructions
  " =========================================
  syntax keyword riscvPseudo li la mv not neg seqz snez sltz sgtz
  syntax keyword riscvPseudo beqz bnez blez bgez bltz bgtz
  syntax keyword riscvPseudo j jr ret call tail
  syntax keyword riscvPseudo nop

  " =========================================
  " RV32M Extension (Multiply/Divide)
  " =========================================
  syntax keyword riscvInstruction mul mulh mulhsu mulhu div divu rem remu

  " =========================================
  " Registers
  " =========================================
  " Named registers
  syntax keyword riscvRegister zero ra sp gp tp fp
  syntax keyword riscvRegister t0 t1 t2 t3 t4 t5 t6
  syntax keyword riscvRegister s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11
  syntax keyword riscvRegister a0 a1 a2 a3 a4 a5 a6 a7

  " Numbered registers
  syntax keyword riscvRegister x0 x1 x2 x3 x4 x5 x6 x7
  syntax keyword riscvRegister x8 x9 x10 x11 x12 x13 x14 x15
  syntax keyword riscvRegister x16 x17 x18 x19 x20 x21 x22 x23
  syntax keyword riscvRegister x24 x25 x26 x27 x28 x29 x30 x31

  " =========================================
  " Assembler Directives
  " =========================================
  syntax match riscvDirective /\.\(section\|text\|data\|rodata\|bss\)\>/
  syntax match riscvDirective /\.\(align\|balign\|p2align\)\>/
  syntax match riscvDirective /\.\(globl\|global\|local\|weak\)\>/
  syntax match riscvDirective /\.\(byte\|half\|word\|dword\)\>/
  syntax match riscvDirective /\.\(asciz\|ascii\|string\)\>/
  syntax match riscvDirective /\.\(zero\|fill\|space\)\>/
  syntax match riscvDirective /\.\(equ\|set\|equiv\)\>/
  syntax match riscvDirective /\.\(type\|size\|file\|ident\)\>/
  syntax match riscvDirective /\.\(option\|attribute\)\>/

  " =========================================
  " Numbers
  " =========================================
  " Hexadecimal
  syntax match riscvNumber /\<0x[0-9a-fA-F]\+\>/
  " Binary
  syntax match riscvNumber /\<0b[01]\+\>/
  " Decimal
  syntax match riscvNumber /\<-\?[0-9]\+\>/

  " =========================================
  " Labels
  " =========================================
  " Global labels
  syntax match riscvLabel /^\s*[a-zA-Z_][a-zA-Z0-9_]*:/
  " Local (numeric) labels
  syntax match riscvLocalLabel /\<[0-9]\+[fb]\>/

  " =========================================
  " Comments
  " =========================================
  syntax match riscvComment /#.*$/

  " =========================================
  " Strings
  " =========================================
  syntax region riscvString start=/"/ skip=/\\"/ end=/"/

  " =========================================
  " Memory offset notation: offset(register)
  " =========================================
  syntax match riscvOffset /\<-\?[0-9]\+\s*(/ contains=riscvNumber

  " =========================================
  " Highlight Links
  " =========================================
  highlight default link riscvInstruction Keyword
  highlight default link riscvPseudo Function
  highlight default link riscvRegister Identifier
  highlight default link riscvDirective PreProc
  highlight default link riscvNumber Number
  highlight default link riscvLabel Label
  highlight default link riscvLocalLabel Label
  highlight default link riscvComment Comment
  highlight default link riscvString String
  highlight default link riscvOffset Number
]])

-- Buffer-local keymaps for RISC-V assembly
local map = vim.keymap.set
local opts = { buffer = true }

map("n", "K", function()
  require("util.riscv").lookup_instruction()
end, vim.tbl_extend("force", opts, { desc = "RISC-V: Lookup instruction" }))

map("n", "<leader>ri", function()
  require("util.riscv").lookup_instruction()
end, vim.tbl_extend("force", opts, { desc = "RISC-V: Instruction Reference" }))

map("n", "<leader>rr", function()
  require("util.riscv").lookup_register()
end, vim.tbl_extend("force", opts, { desc = "RISC-V: Register Reference" }))

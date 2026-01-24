-- ============================================================================
-- RISC-V Utility Functions
-- ============================================================================

local M = {}

-- RV32I Instruction Reference
M.instructions = {
  -- R-type
  add = { syntax = "add rd, rs1, rs2", desc = "Addition: rd = rs1 + rs2" },
  sub = { syntax = "sub rd, rs1, rs2", desc = "Subtraction: rd = rs1 - rs2" },
  sll = { syntax = "sll rd, rs1, rs2", desc = "Shift Left Logical: rd = rs1 << rs2[4:0]" },
  slt = { syntax = "slt rd, rs1, rs2", desc = "Set Less Than (signed): rd = (rs1 < rs2) ? 1 : 0" },
  sltu = { syntax = "sltu rd, rs1, rs2", desc = "Set Less Than Unsigned: rd = (rs1 < rs2) ? 1 : 0" },
  xor = { syntax = "xor rd, rs1, rs2", desc = "XOR: rd = rs1 ^ rs2" },
  srl = { syntax = "srl rd, rs1, rs2", desc = "Shift Right Logical: rd = rs1 >> rs2[4:0]" },
  sra = { syntax = "sra rd, rs1, rs2", desc = "Shift Right Arithmetic: rd = rs1 >>> rs2[4:0]" },
  ["or"] = { syntax = "or rd, rs1, rs2", desc = "OR: rd = rs1 | rs2" },
  ["and"] = { syntax = "and rd, rs1, rs2", desc = "AND: rd = rs1 & rs2" },

  -- I-type (Arithmetic)
  addi = { syntax = "addi rd, rs1, imm", desc = "Add Immediate: rd = rs1 + sext(imm)" },
  slti = { syntax = "slti rd, rs1, imm", desc = "Set Less Than Immediate (signed)" },
  sltiu = { syntax = "sltiu rd, rs1, imm", desc = "Set Less Than Immediate Unsigned" },
  xori = { syntax = "xori rd, rs1, imm", desc = "XOR Immediate: rd = rs1 ^ sext(imm)" },
  ori = { syntax = "ori rd, rs1, imm", desc = "OR Immediate: rd = rs1 | sext(imm)" },
  andi = { syntax = "andi rd, rs1, imm", desc = "AND Immediate: rd = rs1 & sext(imm)" },
  slli = { syntax = "slli rd, rs1, shamt", desc = "Shift Left Logical Immediate" },
  srli = { syntax = "srli rd, rs1, shamt", desc = "Shift Right Logical Immediate" },
  srai = { syntax = "srai rd, rs1, shamt", desc = "Shift Right Arithmetic Immediate" },

  -- Load
  lb = { syntax = "lb rd, offset(rs1)", desc = "Load Byte (signed extend)" },
  lh = { syntax = "lh rd, offset(rs1)", desc = "Load Halfword (signed extend)" },
  lw = { syntax = "lw rd, offset(rs1)", desc = "Load Word" },
  lbu = { syntax = "lbu rd, offset(rs1)", desc = "Load Byte Unsigned" },
  lhu = { syntax = "lhu rd, offset(rs1)", desc = "Load Halfword Unsigned" },

  -- Store
  sb = { syntax = "sb rs2, offset(rs1)", desc = "Store Byte" },
  sh = { syntax = "sh rs2, offset(rs1)", desc = "Store Halfword" },
  sw = { syntax = "sw rs2, offset(rs1)", desc = "Store Word" },

  -- Branch
  beq = { syntax = "beq rs1, rs2, offset", desc = "Branch if Equal" },
  bne = { syntax = "bne rs1, rs2, offset", desc = "Branch if Not Equal" },
  blt = { syntax = "blt rs1, rs2, offset", desc = "Branch if Less Than (signed)" },
  bge = { syntax = "bge rs1, rs2, offset", desc = "Branch if Greater or Equal (signed)" },
  bltu = { syntax = "bltu rs1, rs2, offset", desc = "Branch if Less Than Unsigned" },
  bgeu = { syntax = "bgeu rs1, rs2, offset", desc = "Branch if Greater or Equal Unsigned" },

  -- Jump
  jal = { syntax = "jal rd, offset", desc = "Jump And Link: rd = PC+4; PC += sext(offset)" },
  jalr = { syntax = "jalr rd, rs1, offset", desc = "Jump And Link Register: rd = PC+4; PC = (rs1+sext(offset))&~1" },

  -- Upper Immediate
  lui = { syntax = "lui rd, imm", desc = "Load Upper Immediate: rd = imm << 12" },
  auipc = { syntax = "auipc rd, imm", desc = "Add Upper Immediate to PC: rd = PC + (imm << 12)" },

  -- Pseudo instructions
  li = { syntax = "li rd, imm", desc = "Load Immediate (pseudo): rd = imm" },
  la = { syntax = "la rd, symbol", desc = "Load Address (pseudo): rd = &symbol" },
  mv = { syntax = "mv rd, rs", desc = "Move (pseudo): rd = rs (addi rd, rs, 0)" },
  ["not"] = { syntax = "not rd, rs", desc = "NOT (pseudo): rd = ~rs (xori rd, rs, -1)" },
  neg = { syntax = "neg rd, rs", desc = "Negate (pseudo): rd = -rs (sub rd, x0, rs)" },
  j = { syntax = "j offset", desc = "Jump (pseudo): jal x0, offset" },
  jr = { syntax = "jr rs", desc = "Jump Register (pseudo): jalr x0, rs, 0" },
  ret = { syntax = "ret", desc = "Return (pseudo): jalr x0, ra, 0" },
  call = { syntax = "call symbol", desc = "Call (pseudo): auipc ra, hi(symbol); jalr ra, lo(symbol)(ra)" },
  nop = { syntax = "nop", desc = "No Operation (pseudo): addi x0, x0, 0" },
  beqz = { syntax = "beqz rs, offset", desc = "Branch if == Zero (pseudo): beq rs, x0, offset" },
  bnez = { syntax = "bnez rs, offset", desc = "Branch if != Zero (pseudo): bne rs, x0, offset" },
  blez = { syntax = "blez rs, offset", desc = "Branch if <= Zero (pseudo): bge x0, rs, offset" },
  bgez = { syntax = "bgez rs, offset", desc = "Branch if >= Zero (pseudo): bge rs, x0, offset" },
  bltz = { syntax = "bltz rs, offset", desc = "Branch if < Zero (pseudo): blt rs, x0, offset" },
  bgtz = { syntax = "bgtz rs, offset", desc = "Branch if > Zero (pseudo): blt x0, rs, offset" },
}

-- Register information
M.registers = {
  x0 = { alias = "zero", desc = "Hardwired zero" },
  x1 = { alias = "ra", desc = "Return address" },
  x2 = { alias = "sp", desc = "Stack pointer" },
  x3 = { alias = "gp", desc = "Global pointer" },
  x4 = { alias = "tp", desc = "Thread pointer" },
  x5 = { alias = "t0", desc = "Temporary / Alternate link register" },
  x6 = { alias = "t1", desc = "Temporary" },
  x7 = { alias = "t2", desc = "Temporary" },
  x8 = { alias = "s0/fp", desc = "Saved register / Frame pointer" },
  x9 = { alias = "s1", desc = "Saved register" },
  x10 = { alias = "a0", desc = "Function argument / Return value" },
  x11 = { alias = "a1", desc = "Function argument / Return value" },
  x12 = { alias = "a2", desc = "Function argument" },
  x13 = { alias = "a3", desc = "Function argument" },
  x14 = { alias = "a4", desc = "Function argument" },
  x15 = { alias = "a5", desc = "Function argument" },
  x16 = { alias = "a6", desc = "Function argument" },
  x17 = { alias = "a7", desc = "Function argument" },
  x18 = { alias = "s2", desc = "Saved register" },
  x19 = { alias = "s3", desc = "Saved register" },
  x20 = { alias = "s4", desc = "Saved register" },
  x21 = { alias = "s5", desc = "Saved register" },
  x22 = { alias = "s6", desc = "Saved register" },
  x23 = { alias = "s7", desc = "Saved register" },
  x24 = { alias = "s8", desc = "Saved register" },
  x25 = { alias = "s9", desc = "Saved register" },
  x26 = { alias = "s10", desc = "Saved register" },
  x27 = { alias = "s11", desc = "Saved register" },
  x28 = { alias = "t3", desc = "Temporary" },
  x29 = { alias = "t4", desc = "Temporary" },
  x30 = { alias = "t5", desc = "Temporary" },
  x31 = { alias = "t6", desc = "Temporary" },
}

-- Alias to canonical register mapping
M.alias_map = {
  zero = "x0", ra = "x1", sp = "x2", gp = "x3", tp = "x4",
  t0 = "x5", t1 = "x6", t2 = "x7", fp = "x8", s0 = "x8", s1 = "x9",
  a0 = "x10", a1 = "x11", a2 = "x12", a3 = "x13", a4 = "x14",
  a5 = "x15", a6 = "x16", a7 = "x17",
  s2 = "x18", s3 = "x19", s4 = "x20", s5 = "x21", s6 = "x22",
  s7 = "x23", s8 = "x24", s9 = "x25", s10 = "x26", s11 = "x27",
  t3 = "x28", t4 = "x29", t5 = "x30", t6 = "x31",
}

-- Lookup instruction under cursor
function M.lookup_instruction()
  local word = vim.fn.expand("<cword>")
  local info = M.instructions[word:lower()]

  if info then
    local msg = string.format("**%s**\n\nSyntax: `%s`\n\n%s", word:upper(), info.syntax, info.desc)
    vim.notify(msg, vim.log.levels.INFO, { title = "RISC-V Instruction" })
  else
    vim.notify("Unknown instruction: " .. word, vim.log.levels.WARN, { title = "RISC-V" })
  end
end

-- Lookup register under cursor
function M.lookup_register()
  local word = vim.fn.expand("<cword>"):lower()
  local canonical = M.alias_map[word] or word
  local info = M.registers[canonical]

  if info then
    local msg = string.format("**%s (%s)**\n\n%s", canonical:upper(), info.alias, info.desc)
    vim.notify(msg, vim.log.levels.INFO, { title = "RISC-V Register" })
  else
    vim.notify("Unknown register: " .. word, vim.log.levels.WARN, { title = "RISC-V" })
  end
end

-- Show all registers
function M.show_registers()
  local lines = { "# RISC-V Registers", "" }
  for i = 0, 31 do
    local reg = "x" .. i
    local info = M.registers[reg]
    table.insert(lines, string.format("| %s | %-6s | %s |", reg, info.alias, info.desc))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "RISC-V Registers" })
end

return M

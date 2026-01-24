-- ============================================================================
-- RISC-V Assembly Support
-- ============================================================================

return {
  -- RISC-V completion source for nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Custom RISC-V completion source
      local riscv_source = {}

      function riscv_source:is_available()
        return vim.bo.filetype == "asm"
      end

      function riscv_source:get_keyword_pattern()
        return [[\w\+]]
      end

      function riscv_source:complete(params, callback)
        local items = {}

        -- RV32I Instructions
        local instructions = {
          -- R-type
          { label = "add", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 + rs2" },
          { label = "sub", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 - rs2" },
          { label = "sll", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 << rs2[4:0]" },
          { label = "slt", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = (rs1 < rs2) ? 1 : 0 (signed)" },
          { label = "sltu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = (rs1 < rs2) ? 1 : 0 (unsigned)" },
          { label = "xor", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 ^ rs2" },
          { label = "srl", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 >> rs2[4:0] (logical)" },
          { label = "sra", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 >> rs2[4:0] (arithmetic)" },
          { label = "or", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 | rs2" },
          { label = "and", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 & rs2" },
          -- I-type
          { label = "addi", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 + sext(imm)" },
          { label = "slti", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = (rs1 < sext(imm)) ? 1 : 0" },
          { label = "sltiu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = (rs1 < sext(imm)) ? 1 : 0 (unsigned)" },
          { label = "xori", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 ^ sext(imm)" },
          { label = "ori", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 | sext(imm)" },
          { label = "andi", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 & sext(imm)" },
          { label = "slli", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 << shamt" },
          { label = "srli", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 >> shamt (logical)" },
          { label = "srai", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = rs1 >> shamt (arithmetic)" },
          -- Load
          { label = "lb", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = sext(M[rs1+imm][7:0])" },
          { label = "lh", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = sext(M[rs1+imm][15:0])" },
          { label = "lw", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = M[rs1+imm][31:0]" },
          { label = "lbu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = zext(M[rs1+imm][7:0])" },
          { label = "lhu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = zext(M[rs1+imm][15:0])" },
          -- Store
          { label = "sb", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "M[rs1+imm][7:0] = rs2[7:0]" },
          { label = "sh", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "M[rs1+imm][15:0] = rs2[15:0]" },
          { label = "sw", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "M[rs1+imm][31:0] = rs2" },
          -- Branch
          { label = "beq", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 == rs2) PC += sext(imm)" },
          { label = "bne", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 != rs2) PC += sext(imm)" },
          { label = "blt", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 < rs2) PC += sext(imm) (signed)" },
          { label = "bge", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 >= rs2) PC += sext(imm) (signed)" },
          { label = "bltu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 < rs2) PC += sext(imm) (unsigned)" },
          { label = "bgeu", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "if (rs1 >= rs2) PC += sext(imm) (unsigned)" },
          -- Jump
          { label = "jal", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = PC+4; PC += sext(imm)" },
          { label = "jalr", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = PC+4; PC = (rs1+sext(imm))&~1" },
          -- Upper immediate
          { label = "lui", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = imm << 12" },
          { label = "auipc", kind = cmp.lsp.CompletionItemKind.Keyword, detail = "rd = PC + (imm << 12)" },
          -- Pseudo instructions
          { label = "li", kind = cmp.lsp.CompletionItemKind.Function, detail = "Load immediate (pseudo)" },
          { label = "la", kind = cmp.lsp.CompletionItemKind.Function, detail = "Load address (pseudo)" },
          { label = "mv", kind = cmp.lsp.CompletionItemKind.Function, detail = "rd = rs (pseudo)" },
          { label = "not", kind = cmp.lsp.CompletionItemKind.Function, detail = "rd = ~rs (pseudo)" },
          { label = "neg", kind = cmp.lsp.CompletionItemKind.Function, detail = "rd = -rs (pseudo)" },
          { label = "j", kind = cmp.lsp.CompletionItemKind.Function, detail = "Jump (pseudo)" },
          { label = "jr", kind = cmp.lsp.CompletionItemKind.Function, detail = "Jump register (pseudo)" },
          { label = "ret", kind = cmp.lsp.CompletionItemKind.Function, detail = "Return (pseudo)" },
          { label = "call", kind = cmp.lsp.CompletionItemKind.Function, detail = "Call function (pseudo)" },
          { label = "nop", kind = cmp.lsp.CompletionItemKind.Function, detail = "No operation (pseudo)" },
          { label = "beqz", kind = cmp.lsp.CompletionItemKind.Function, detail = "Branch if == zero (pseudo)" },
          { label = "bnez", kind = cmp.lsp.CompletionItemKind.Function, detail = "Branch if != zero (pseudo)" },
        }

        for _, instr in ipairs(instructions) do
          table.insert(items, instr)
        end

        -- Registers
        local registers = {
          "zero", "ra", "sp", "gp", "tp",
          "t0", "t1", "t2", "t3", "t4", "t5", "t6",
          "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11",
          "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",
          "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7",
          "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15",
          "x16", "x17", "x18", "x19", "x20", "x21", "x22", "x23",
          "x24", "x25", "x26", "x27", "x28", "x29", "x30", "x31",
        }
        for _, reg in ipairs(registers) do
          table.insert(items, {
            label = reg,
            kind = cmp.lsp.CompletionItemKind.Variable,
          })
        end

        -- Directives
        local directives = {
          ".section", ".text", ".data", ".rodata", ".bss",
          ".align", ".globl", ".global", ".word", ".byte", ".half", ".asciz", ".string",
        }
        for _, dir in ipairs(directives) do
          table.insert(items, {
            label = dir,
            kind = cmp.lsp.CompletionItemKind.Snippet,
          })
        end

        callback({ items = items })
      end

      cmp.register_source("riscv", riscv_source)

      -- Add to sources for asm filetype
      local sources = opts.sources or {}
      table.insert(sources, 1, { name = "riscv", priority = 1000 })
      opts.sources = sources

      return opts
    end,
  },
}

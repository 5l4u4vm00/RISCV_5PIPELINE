-- ============================================================================
-- Verilog/SystemVerilog Support
-- ============================================================================

return {
  -- Verilog syntax and utilities
  {
    "vhda/verilog_systemverilog.vim",
    ft = { "verilog", "systemverilog" },
    config = function()
      -- Module folding
      vim.g.verilog_syntax_fold_lst = "module,function,task"
      -- Disable automatic indentation (use treesitter)
      vim.g.verilog_disable_indent_lst = "module,interface"
    end,
  },

  -- Auto-completion enhancements for Verilog
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Verilog keywords for completion
      local verilog_keywords = {
        -- Module structure
        "module",
        "endmodule",
        "input",
        "output",
        "inout",
        "wire",
        "reg",
        "logic",
        "parameter",
        "localparam",
        -- Control flow
        "always",
        "always_ff",
        "always_comb",
        "always_latch",
        "initial",
        "assign",
        "if",
        "else",
        "case",
        "endcase",
        "for",
        "while",
        "begin",
        "end",
        -- Data types
        "integer",
        "real",
        "time",
        "bit",
        "byte",
        "shortint",
        "int",
        "longint",
        -- Timing
        "posedge",
        "negedge",
        "@",
        "#",
        -- System tasks
        "$display",
        "$monitor",
        "$finish",
        "$readmemh",
        "$readmemb",
        "$fopen",
        "$fclose",
        "$dumpfile",
        "$dumpvars",
      }

      -- Add Verilog-specific source
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "buffer" })

      return opts
    end,
  },
}

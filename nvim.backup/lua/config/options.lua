-- ============================================================================
-- Vim Options
-- ============================================================================

local opt = vim.opt

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 300

-- Split behavior
opt.splitright = true
opt.splitbelow = true

-- File encoding
opt.fileencoding = "utf-8"

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Fold settings (for Verilog modules)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- Error format for Verilog/RISC-V tools
opt.errorformat:prepend(
  -- Icarus Verilog
  "%f:%l: %trror: %m,"
    .. "%f:%l: %tarning: %m,"
    .. "%f:%l: syntax error,"
    -- Verilator
    .. "%%Error: %f:%l:%c: %m,"
    .. "%%Error: %f:%l: %m,"
    .. "%%Warning-%*[A-Z]: %f:%l:%c: %m,"
    -- RISC-V assembler
    .. "%f:%l: %m,"
    .. "%f:(%l): %m"
)

-- File type associations
vim.filetype.add({
  extension = {
    sv = "systemverilog",
    svh = "systemverilog",
    v = "verilog",
    vh = "verilog",
    S = "asm",
  },
})

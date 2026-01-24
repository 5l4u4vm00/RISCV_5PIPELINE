-- ============================================================================
-- Auto Commands
-- ============================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- RISC-V CPU Project auto commands
local riscv_grp = augroup("RiscvCpu", { clear = true })

-- LSP crash auto-restart
autocmd("LspDetach", {
  group = riscv_grp,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.is_stopped and client.is_stopped() then
      vim.defer_fn(function()
        vim.cmd("LspStart " .. client.name)
      end, 1000)
    end
  end,
  desc = "Auto-restart LSP on crash",
})

-- Auto-open quickfix after make commands
autocmd("QuickFixCmdPost", {
  group = riscv_grp,
  pattern = "*",
  callback = function()
    vim.cmd("copen")
  end,
})

-- Assembly file settings
autocmd({ "BufRead", "BufNewFile" }, {
  group = riscv_grp,
  pattern = "*.S",
  callback = function()
    vim.bo.filetype = "asm"
    vim.bo.commentstring = "# %s"
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

-- Verilog file settings
autocmd({ "BufRead", "BufNewFile" }, {
  group = riscv_grp,
  pattern = { "*.sv", "*.svh" },
  callback = function()
    vim.bo.filetype = "systemverilog"
    vim.bo.commentstring = "// %s"
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Resize splits when window is resized
autocmd("VimResized", {
  group = augroup("ResizeSplits", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Return to last edit position
autocmd("BufReadPost", {
  group = augroup("LastPosition", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

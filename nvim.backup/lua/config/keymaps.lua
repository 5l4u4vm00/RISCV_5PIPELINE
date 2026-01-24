-- ============================================================================
-- Keymaps
-- ============================================================================

local map = vim.keymap.set

-- ============================================
-- RISC-V Development (<leader>r)
-- ============================================
map("n", "<leader>ri", function()
  require("util.riscv").lookup_instruction()
end, { desc = "RISC-V: Instruction Reference" })

map("n", "<leader>rr", function()
  require("util.riscv").lookup_register()
end, { desc = "RISC-V: Register Reference" })

map("n", "<leader>rR", function()
  require("util.riscv").show_registers()
end, { desc = "RISC-V: Show All Registers" })

map("n", "<leader>rv", function()
  local dump_file = vim.fn.getcwd() .. "/workspace/sim/prog0/main.dump"
  if vim.fn.filereadable(dump_file) == 1 then
    vim.cmd("vsplit " .. dump_file)
  else
    vim.notify("Dump file not found: " .. dump_file, vim.log.levels.WARN)
  end
end, { desc = "RISC-V: View Disassembly" })

-- ============================================
-- Verilog/HDL Development (<leader>v)
-- ============================================
map("n", "<leader>vl", function()
  vim.cmd("!cd workspace && make lint")
end, { desc = "Verilog: Lint Check" })

map("n", "<leader>vf", function()
  require("conform").format({ async = true })
end, { desc = "Verilog: Format File" })

-- ============================================
-- Simulation (<leader>s)
-- ============================================
map("n", "<leader>ss", function()
  vim.cmd("!cd workspace && make sim")
end, { desc = "Sim: Run Simulation" })

map("n", "<leader>sw", function()
  vim.cmd("!cd workspace && make sim_wave")
end, { desc = "Sim: Run with Waveform" })

map("n", "<leader>sg", function()
  vim.cmd("!cd workspace && gtkwave src/output/wave.vcd &")
end, { desc = "Sim: Open GTKWave" })

map("n", "<leader>sc", function()
  vim.cmd("!cd workspace && make clean")
end, { desc = "Sim: Clean Build" })

map("n", "<leader>sp", function()
  -- Select program directory
  local handle = io.popen("ls -d workspace/sim/prog*/ 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    local progs = {}
    for prog in result:gmatch("[^\n]+") do
      table.insert(progs, prog:match("prog%d+"))
    end
    if #progs > 0 then
      vim.ui.select(progs, { prompt = "Select Program:" }, function(choice)
        if choice then
          vim.cmd("!cd workspace && make sim PROG=" .. choice)
        end
      end)
    else
      vim.notify("No programs found in workspace/sim/", vim.log.levels.WARN)
    end
  end
end, { desc = "Sim: Select & Run Program" })

-- ============================================
-- Make Commands (<leader>m)
-- ============================================
map("n", "<leader>mm", function()
  vim.cmd("!cd workspace && make")
end, { desc = "Make: Default Target" })

map("n", "<leader>mc", function()
  vim.cmd("!cd workspace && make compile")
end, { desc = "Make: Compile" })

map("n", "<leader>ma", function()
  vim.cmd("!cd workspace && make asm")
end, { desc = "Make: Assemble" })

map("n", "<leader>mh", function()
  vim.cmd("!cd workspace && make help")
end, { desc = "Make: Show Help" })

-- ============================================
-- Debug (<leader>d)
-- ============================================
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Conditional Breakpoint" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug: Continue" })

map("n", "<leader>ds", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over" })

map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })

map("n", "<leader>do", function()
  require("dap").step_out()
end, { desc = "Debug: Step Out" })

map("n", "<leader>dr", function()
  require("dap").repl.open()
end, { desc = "Debug: Open REPL" })

map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug: Toggle UI" })

map("n", "<leader>dq", function()
  require("dap").terminate()
end, { desc = "Debug: Terminate" })

-- ============================================
-- LSP
-- ============================================
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP: Restart" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP: Info" })

-- ============================================
-- General
-- ============================================
-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

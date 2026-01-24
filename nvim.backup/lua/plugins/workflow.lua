-- ============================================================================
-- Workflow Automation (Terminal, Tasks, Quickfix)
-- ============================================================================

return {
  -- ToggleTerm (floating/split terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal: Toggle" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal: Float" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal: Horizontal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal: Vertical" },
    },
  },

  -- Overseer (task runner)
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = "toggleterm",
      templates = { "builtin" },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- Register RISC-V project tasks
      overseer.register_template({
        name = "make sim",
        builder = function()
          return {
            cmd = { "make" },
            args = { "sim" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = {
              { "on_output_quickfix", open = true },
              "default",
            },
          }
        end,
        desc = "Run RISC-V simulation",
        tags = { "BUILD" },
      })

      overseer.register_template({
        name = "make sim_wave",
        builder = function()
          return {
            cmd = { "make" },
            args = { "sim_wave" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = { "default" },
          }
        end,
        desc = "Run simulation with waveform output",
        tags = { "BUILD" },
      })

      overseer.register_template({
        name = "make compile",
        builder = function()
          return {
            cmd = { "make" },
            args = { "compile" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = {
              { "on_output_quickfix", open = true },
              "default",
            },
          }
        end,
        desc = "Compile Verilog design",
        tags = { "BUILD" },
      })

      overseer.register_template({
        name = "make clean",
        builder = function()
          return {
            cmd = { "make" },
            args = { "clean" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = { "default" },
          }
        end,
        desc = "Clean build artifacts",
        tags = { "BUILD" },
      })

      overseer.register_template({
        name = "GTKWave",
        builder = function()
          return {
            cmd = { "gtkwave" },
            args = { "src/output/wave.vcd" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = { "default" },
          }
        end,
        desc = "Open GTKWave waveform viewer",
        tags = { "DEBUG" },
      })

      overseer.register_template({
        name = "make asm",
        builder = function()
          return {
            cmd = { "make" },
            args = { "asm" },
            cwd = vim.fn.getcwd() .. "/workspace",
            components = {
              { "on_output_quickfix", open = true },
              "default",
            },
          }
        end,
        desc = "Assemble RISC-V program",
        tags = { "BUILD" },
      })
    end,
    keys = {
      { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle" },
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
      { "<leader>ol", "<cmd>OverseerRestartLast<cr>", desc = "Overseer: Restart Last" },
    },
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = "rounded",
      },
      filter = {
        fzf = {
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
  },
}

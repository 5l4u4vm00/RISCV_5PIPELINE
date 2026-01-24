-- ============================================================================
-- Debug Adapter Protocol (DAP) Configuration
-- ============================================================================

return {
  -- nvim-dap (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")

      -- RISC-V GDB Adapter
      dap.adapters.riscv_gdb = {
        type = "executable",
        command = "riscv32-unknown-elf-gdb",
        args = { "-i", "dap" },
      }

      -- Alternative: GDB Multiarch
      dap.adapters.gdb_multiarch = {
        type = "executable",
        command = "gdb-multiarch",
        args = { "-i", "dap" },
      }

      -- RISC-V Debug configurations
      dap.configurations.asm = {
        {
          name = "Debug RISC-V ELF",
          type = "riscv_gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/workspace/sim/prog0/main.elf", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
        },
        {
          name = "Attach to QEMU (port 1234)",
          type = "riscv_gdb",
          request = "attach",
          target = "localhost:1234",
          program = function()
            return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/workspace/sim/prog0/main.elf", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Attach to Spike (port 9824)",
          type = "riscv_gdb",
          request = "attach",
          target = "localhost:9824",
          program = function()
            return vim.fn.input("Path to ELF: ", vim.fn.getcwd() .. "/workspace/sim/prog0/main.elf", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }

      -- C/C++ configurations (for Verilator testbenches)
      dap.configurations.c = {
        {
          name = "Debug C/C++ (gdb)",
          type = "gdb_multiarch",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- DAP signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◇", texthl = "DapLogPoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "→" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
        },
      })

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Virtual text for DAP
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      enabled = true,
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
    },
  },
}

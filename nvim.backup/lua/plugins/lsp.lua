-- ============================================================================
-- LSP Configuration (Stability Fix)
-- ============================================================================

return {
  -- Mason (LSP/DAP/Linter installer)
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "svls", -- SystemVerilog LSP (primary)
        "verible", -- Verilog formatter/linter
        "lua-language-server",
        "stylua",
      },
    },
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Diagnostic settings for stability
      diagnostics = {
        underline = true,
        update_in_insert = false, -- Don't update diagnostics in insert mode
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      },

      -- Inlay hints
      inlay_hints = {
        enabled = false, -- Disable for performance
      },

      -- Server configurations
      servers = {
        -- SystemVerilog LSP (primary - most stable)
        svls = {
          cmd = { "svls" },
          filetypes = { "verilog", "systemverilog" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("*.sv", "*.v", "Makefile")(fname)
              or vim.fn.getcwd()
          end,
          settings = {
            svls = {
              includeIndexing = { "**/*.{sv,v,svh,vh}" },
              excludeIndexing = { "sim/**", "**/*.vcd" },
            },
          },
          flags = {
            debounce_text_changes = 500, -- Reduce frequent requests
          },
          on_attach = function(client, bufnr)
            -- Disable formatting (use conform.nvim instead)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },

        -- Verible (disabled by default, use as fallback)
        -- verible = {
        --   autostart = false,
        -- },

        -- Lua LSP
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
      },

      -- Setup handlers
      setup = {
        -- Global handler for all LSP servers
        ["*"] = function(server, opts)
          opts.flags = opts.flags or {}
          opts.flags.debounce_text_changes = opts.flags.debounce_text_changes or 300
          opts.flags.allow_incremental_sync = true
        end,
      },
    },

    config = function(_, opts)
      -- LSP restart command
      vim.api.nvim_create_user_command("LspRestart", function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
        vim.cmd("edit")
      end, { desc = "Restart all LSP clients" })

      -- LSP info command
      vim.api.nvim_create_user_command("LspInfo", function()
        vim.cmd("checkhealth lspconfig")
      end, { desc = "Show LSP info" })

      -- Better LSP error handling
      vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({ "ERROR", "WARN", "INFO", "DEBUG" })[result.type]
        vim.notify(result.message, vim.log.levels[lvl], {
          title = client and client.name or "LSP",
        })
      end
    end,
  },

  -- Conform (formatting)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        verilog = { "verible" },
        systemverilog = { "verible" },
        lua = { "stylua" },
        python = { "black" },
      },
      formatters = {
        verible = {
          command = "verible-verilog-format",
          args = {
            "--indentation_spaces=2",
            "--port_declarations_indentation=indent",
            "-",
          },
        },
      },
      format_on_save = false, -- Manual format only
    },
  },

  -- Trouble (better diagnostics list)
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        -- Verilog-specific diagnostics view
        verilog_diag = {
          mode = "diagnostics",
          filter = {
            any = {
              buf = 0,
              function(item)
                return item.filename:match("%.sv$") or item.filename:match("%.v$")
              end,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>xv", "<cmd>Trouble verilog_diag toggle<cr>", desc = "Verilog Diagnostics" },
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    },
  },
}

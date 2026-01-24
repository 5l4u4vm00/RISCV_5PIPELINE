-- ============================================================================
-- Core Plugins (LazyVim + Theme + UI)
-- ============================================================================

return {
  -- TokyoNight colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
      on_colors = function(colors)
        -- Custom colors for HDL development
        colors.hint = colors.teal
        colors.error = colors.red1
      end,
      on_highlights = function(hl, c)
        -- Verilog/SystemVerilog highlights
        hl["@keyword.verilog"] = { fg = c.purple }
        hl["@type.verilog"] = { fg = c.blue1 }
        hl["@function.verilog"] = { fg = c.blue }
      end,
    },
  },

  -- Lualine (status bar)
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 1, -- relative path
            symbols = {
              modified = " [+]",
              readonly = " [-]",
              unnamed = "[No Name]",
            },
          },
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Neo-tree (file explorer)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            "node_modules",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
        follow_current_file = {
          enabled = true,
        },
      },
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  -- Which-key (keybinding hints)
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>r", group = "RISC-V", icon = "" },
        { "<leader>v", group = "Verilog", icon = "" },
        { "<leader>s", group = "Simulation", icon = "" },
        { "<leader>d", group = "Debug", icon = "" },
        { "<leader>m", group = "Make", icon = "" },
        { "<leader>t", group = "Terminal", icon = "" },
      },
    },
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "%.vcd",
          "%.fst",
          "%.o",
          "%.elf",
          "%.hex",
          "%.out",
          "node_modules",
          ".git/",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    },
    keys = {
      -- Project specific file searches
      { "<leader>fs", "<cmd>Telescope find_files cwd=workspace/src<cr>", desc = "Find: Source Files" },
      { "<leader>fa", "<cmd>Telescope find_files cwd=workspace/sim<cr>", desc = "Find: Sim Files" },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "verilog",
        "c",
        "cpp",
        "python",
        "lua",
        "bash",
        "make",
        "markdown",
        "yaml",
        "json",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "asm" }, -- Enable for assembly
      },
      indent = {
        enable = true,
      },
    },
  },

  -- Mini.nvim utilities
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Surround
      require("mini.surround").setup()
      -- Comment
      require("mini.comment").setup()
      -- Pairs
      require("mini.pairs").setup()
    end,
  },
}

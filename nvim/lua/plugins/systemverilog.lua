return {
	-- ===================================
	-- Treesitter highlight
	-- ===================================
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- comfirm install verilog parser
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "verilog" })
		end,
	},

	-- ===================================
	-- LSP setting - Verible
	-- ===================================
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				verible = {
					-- 啟用規則設定檔搜尋
					cmd = { "verible-verilog-ls", "--rules_config_search" },
					-- default filetypes: { "systemverilog", "verilog" }
					-- default root_dir: find .git
				},
			},
		},
	},

	-- ===================================
	-- formate setting（option）
	-- ===================================
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				verilog = { "verible_verilog_format" },
				systemverilog = { "verible_verilog_format" },
			},
			formatters = {
				verible_verilog_format = {
					command = "verible-verilog-format",
					args = { "-" },
					stdin = true,
				},
			},
		},
	},
}

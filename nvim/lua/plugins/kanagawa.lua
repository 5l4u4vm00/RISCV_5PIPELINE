return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- your kanagawa options here (optional)
			transparent = false,
			theme = "dragon", -- "wave", "dragon", or "lotus"
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "kanagawa-dragon",
		},
	},
}

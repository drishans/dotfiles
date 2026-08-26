require("gitsigns").setup()

require("which-key").setup()

require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
	},
})

require("oil").setup({
	default_file_explorer = true,
	view_options = {
		show_hidden = true,
	},
})

local telescope = require("telescope")
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
		},
	},
})
pcall(telescope.load_extension, "fzf")

require("blink.cmp").setup({
	keymap = { preset = "default" },
	completion = {
		documentation = { auto_show = true },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

require("conform").setup({
	formatters_by_ft = {
		c = { "clang_format" },
		cpp = { "clang_format" },
		css = { "prettier" },
		glsl = { "clang_format" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		nix = { "nixfmt" },
		python = { "black" },
		rust = { "rustfmt" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		yaml = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

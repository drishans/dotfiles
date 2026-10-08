local opt = vim.opt

opt.number = true
opt.wrap = false
opt.backspace = { "indent", "eol", "start" }
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildmenu = true
opt.hidden = true
opt.mouse = "a"
opt.cursorline = true
opt.numberwidth = 6
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.scrolloff = 4

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.autoindent = true

vim.filetype.add({
	extension = {
		frag = "glsl",
		vert = "glsl",
		fp = "glsl",
		vp = "glsl",
		glsl = "glsl",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "python", "rust" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
	end,
})

vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox")

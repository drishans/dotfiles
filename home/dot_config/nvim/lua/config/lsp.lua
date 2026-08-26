local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.enable({
	"bashls",
	"clangd",
	"lua_ls",
	"nil_ls",
	"pyright",
	"rust_analyzer",
	"ts_ls",
})

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded" },
	signs = true,
	underline = true,
	virtual_text = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, {
				buffer = event.buf,
				desc = desc,
			})
		end

		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("gr", vim.lsp.buf.references, "Find references")
		map("K", vim.lsp.buf.hover, "Hover documentation")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	end,
})

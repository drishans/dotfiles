local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>confirm quit<CR>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Search help" })

map("n", "<leader>gs", "<cmd>DiffviewOpen<CR>", { desc = "Review Git changes" })
map("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Review Git history" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "Review file history" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close Git review" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
map("n", "[h", "<cmd>Gitsigns nav_hunk prev<CR>", { desc = "Previous Git hunk" })
map("n", "]h", "<cmd>Gitsigns nav_hunk next<CR>", { desc = "Next Git hunk" })

map("n", "[b", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Not <leader>f: that is the Telescope prefix, and the overlap makes every
-- <leader>f* chord wait out timeoutlen before resolving.
map("n", "<leader>cf", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Diagnostic details" })

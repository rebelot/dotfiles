local copts = { noremap = true }
require("gitsigns").setup({
    trouble = true,
    keymaps = {},
})
vim.api.nvim_set_keymap("n", "<leader>hd", "<cmd>Gitsigns preview_hunk<CR>", copts)
vim.api.nvim_set_keymap("n", "]h", "<cmd>Gitsigns next_hunk<CR>", copts)
vim.api.nvim_set_keymap("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>xh", "<cmd>Gitsigns setloclist<CR>", copts) -- use trouble

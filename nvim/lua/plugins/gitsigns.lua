local map = vim.keymap.set

require("gitsigns").setup({
    trouble = true,
    keymaps = {},
    preview_config = {
        border = require("lsp").borders,
    },
})

map("n", "<leader>hd", "<cmd>Gitsigns preview_hunk_inline<CR>")
map("n", "<leader>hb", "<cmd>Gitsigns blame_line<CR>")
map("n", "]h", "<cmd>Gitsigns next_hunk<CR>")
map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>")
map("n", "<leader>xh", "<cmd>Gitsigns setqflist<CR>") -- use trouble

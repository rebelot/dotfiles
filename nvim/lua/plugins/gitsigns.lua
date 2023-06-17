local map = vim.keymap.set

require("gitsigns").setup({
    trouble = true,
    _inline2 = true,
    preview_config = {
        border = vim.g.FloatBorders
    },
    on_attach = function(bufnr)
        map("n", "<leader>hd", "<cmd>Gitsigns preview_hunk_inline<CR>", { buffer = bufnr })
        map("n", "<leader>hb", "<cmd>Gitsigns blame_line<CR>", { buffer = bufnr })
        map("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { buffer = bufnr })
        map("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { buffer = bufnr })
        map("n", "<leader>xh", "<cmd>Gitsigns setqflist<CR>", { buffer = bufnr }) -- use trouble
    end,
})

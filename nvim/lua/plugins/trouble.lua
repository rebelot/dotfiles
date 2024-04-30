local map = vim.keymap.set

require("trouble").setup({
    -- preview = { type = "float" },
    icons = {
        kinds = require("lsp.init").symbol_icons,
    }
})

map("n", "<leader>xt", "<cmd>Trouble<CR>")
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>")
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>")
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>")
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>")

-- map("n", "]x", function()
--     require("trouble").next()
-- end)
-- map("n", "[x", function()
--     require("trouble").prev()
-- end)

-- vim.cmd([[hi! link TroubleNormal NormalFloat]])
-- vim.cmd([[
--     augroup trouble_au
--     autocmd!
--     autocmd FileType Trouble setl cursorline
--     augroup END
-- ]])

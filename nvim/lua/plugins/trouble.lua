local map = vim.keymap.set

require("trouble").setup({ use_diagnostic_signs = true })

map("n", "<leader>xx", "<cmd>TroubleToggle<CR>")
map("n", "<leader>xD", "<cmd>TroubleToggle workspace_diagnostics<CR>")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>xc", "<cmd>TroubleToggle quickfix<CR>")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>")
map("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<CR>")

map("n", "]x", function()
    pcall(require("trouble").next, { skip_groups = true, jump = true })
end)
map("n", "[x", function()
    pcall(require("trouble").previous, { skip_groups = true, jump = true })
end)

vim.cmd([[hi TroubleText guifg=fg guibg=none]])
vim.cmd([[
    augroup trouble_au
    autocmd!
    autocmd FileType Trouble setl cursorline 
    augroup END
]])

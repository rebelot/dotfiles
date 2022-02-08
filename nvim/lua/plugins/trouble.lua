local copts = {noremap = true}

require'trouble'.setup {
    use_diagnostic_signs = true
}
vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>TroubleToggle<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xD', '<cmd>TroubleToggle workspace_diagnostics<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xc', '<cmd>TroubleToggle quickfix<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xl', '<cmd>TroubleToggle loclist<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xr', '<cmd>TroubleToggle lsp_references<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xn', '<cmd>lua pcall(require("trouble").next, {skip_groups = true, jump = true})<CR>', copts)
vim.api.nvim_set_keymap('n', '<leader>xp', '<cmd>lua pcall(require("trouble").previous, {skip_groups = true, jump = true})<CR>', copts)

vim.cmd [[
    augroup trouble_au
    autocmd!
    autocmd FileType Trouble setl cursorline 
    augroup END
]]

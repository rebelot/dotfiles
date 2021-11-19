vim.g.vista_echo_cursor_strategy = 'floating_win'
vim.g.vista_default_executive = 'nvim_lsp'
vim.g.vista_ctags_executable = 'uctags'
vim.g.vista_executive_for = {
    cpp = 'nvim_lsp',
    python = 'nvim_lsp',
    markdown = 'nvim_lsp',
    lua = 'nvim_lsp'
}
vim.api.nvim_set_keymap('n', '<leader>vv', '<cmd>Vista!!<CR>', {noremap = true})

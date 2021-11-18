local copts = {noremap = true}
-- local ac = require'hop.hint'.HintDirection['AFTER_CURSOR']
-- local bc = require'hop.hint'.HintDirection['BEFORE_CURSOR']

vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char1()<cr>", copts)
vim.api.nvim_set_keymap('x', 's', "<cmd>lua require'hop'.hint_char1()<cr>", copts)
vim.api.nvim_set_keymap('o', 'x', "<cmd>lua require'hop'.hint_char1()<cr>", copts)

vim.api.nvim_set_keymap('n', '<C-s>', "<cmd>lua require'hop'.hint_char2()<cr>", copts)
vim.api.nvim_set_keymap('x', '<C-s>', "<cmd>lua require'hop'.hint_char2()<cr>", copts)
vim.api.nvim_set_keymap('o', '<C-x>',
                        "<cmd>lua require'hop'.hint_char2()<cr>", copts)

vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_lines()<cr>", copts)
vim.api.nvim_set_keymap('x', 'SS', "<cmd>lua require'hop'.hint_lines()<cr>", copts)
vim.api.nvim_set_keymap('o', 'X', "<cmd>lua require'hop'.hint_lines()<cr>", copts)

require'hop'.setup({
    teasing = false
})

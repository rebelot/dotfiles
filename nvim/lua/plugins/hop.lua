local copts = { noremap = true }
-- local ac = require'hop.hint'.HintDirection['AFTER_CURSOR']
-- local bc = require'hop.hint'.HintDirection['BEFORE_CURSOR']

vim.keymap.set({"n", "x"}, "s", require("hop").hint_char2, { desc = "Hop: Hint char2" })
vim.keymap.set({"o"}, "x", require("hop").hint_char2, { desc = "Hop: Hint char2" })

require("hop").setup({
    teasing = false,
    multi_window = true,
    char2_fallback_key = '<CR>'
})

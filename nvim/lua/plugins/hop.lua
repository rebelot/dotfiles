local copts = { noremap = true }
-- local ac = require'hop.hint'.HintDirection['AFTER_CURSOR']
-- local bc = require'hop.hint'.HintDirection['BEFORE_CURSOR']

vim.keymap.set("n", "s", require("hop").hint_char1, { desc = "Hop: Hint char1" })
vim.keymap.set("x", "s", require("hop").hint_char1, { desc = "Hop: Hint char1" })
vim.keymap.set("o", "x", require("hop").hint_char1, { desc = "Hop: Hint char1" })

vim.keymap.set("n", "<C-s>", require("hop").hint_char2, { desc = "Hop: Hint char2" })
vim.keymap.set("x", "<C-s>", require("hop").hint_char2, { desc = "Hop: Hint char2" })
vim.keymap.set("o", "<C-x>", require("hop").hint_char2, { desc = "Hop: Hint char2" })

vim.keymap.set("n", "S", require("hop").hint_lines, { desc = "Hop: Hint lines" })
vim.keymap.set("x", "SS", require("hop").hint_lines, { desc = "Hop: Hint lines" })
vim.keymap.set("o", "X", require("hop").hint_lines, { desc = "Hop: Hint lines" })

require("hop").setup({
    teasing = false,
})

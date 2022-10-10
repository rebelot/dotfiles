local map = vim.keymap.set
-- local ac = require'hop.hint'.HintDirection['AFTER_CURSOR']
-- local bc = require'hop.hint'.HintDirection['BEFORE_CURSOR']

map({ "n", "x" }, "s", require("hop").hint_char2, { desc = "Hop: Hint char2" })
map({ "o" }, "x", require("hop").hint_char2, { desc = "Hop: Hint char2" })
map("n", "S", require("hop").hint_lines_skip_whitespace, { desc = "Hop: Hint line start" })

require("hop").setup({
    teasing = false,
    multi_window = true,
    char2_fallback_key = "<CR>",
})

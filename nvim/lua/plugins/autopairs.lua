require('nvim-autopairs').setup {
    fast_wrap = {
        chars = {'{', '[', '(', '"', "'", '`'},
        map = '<M-l>',
        keys = "asdfghjklqwertyuiop",
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%:] ]], '%s+', ''),
        check_comma = true,
        end_key = 'L',
        highlight = 'HopNextKey',
        hightlight_grey = 'HopUnmatched'
    },
    check_ts = true,
    enable_check_bracket_line = false
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({
    map_char = {
        tex = ''
    }
}))

function EscapePair()
    local closers = {")", "]", "}", ">", "'", '"', "`", ","}
    local line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local after = line:sub(col + 1, -1)
    local closer_col = #after + 1
    local closer_i = nil
    for i, closer in ipairs(closers) do
        local cur_index, _ = after:find(closer)
        if cur_index and (cur_index < closer_col) then
            closer_col = cur_index
            closer_i = i
        end
    end
    if closer_i then
        vim.api.nvim_win_set_cursor(0, {row, col + closer_col})
    else
        vim.api.nvim_win_set_cursor(0, {row, col + 1})
    end
end

vim.api.nvim_set_keymap('i', '<C-l>', '<cmd>lua EscapePair()<CR>', {
    noremap = true,
    silent = true
})

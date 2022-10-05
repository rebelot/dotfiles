local api = vim.api
local map = vim.keymap.set

local function escape_pair()
    -- vim.fn.searchpos
    -- vim.fn.searchpairpos
    local closers = { ")", "]", "}", ">", "'", '"', "`", "," }
    local line = api.nvim_get_current_line()
    local row, col = unpack(api.nvim_win_get_cursor(0))
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
        api.nvim_win_set_cursor(0, { row, col + closer_col })
    else
        api.nvim_win_set_cursor(0, { row, col + 1 })
    end
end

map("i", "<C-l>", escape_pair, { desc = "Escape pair" })

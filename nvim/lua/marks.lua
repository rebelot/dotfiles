local M = {}

local ns = vim.api.nvim_create_namespace("marks")

vim.api.nvim_set_hl(0, "Mark", { bg = vim.api.nvim_get_hl_by_name("NonText", true).foreground })

local config = {
    pos_hl = "Mark",
    sign_hl = "String",
    line_hl = nil,
    num_hl = nil,
    priority = nil,
    local_only = false,
    filter = function(mark)
        return mark:match("[a-zA-Z]")
    end,
    format = function(mark)
        return mark:gsub("'", '')
    end
}

local function set_mark_extmark(bufnr, mark, line, col)
    pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, col, {
        hl_group = config.pos_hl,
        sign_hl_group = config.sign_hl,
        line_hl_group = config.line_hl,
        number_hl_group = config.num_hl,
        end_col = col + 1,
        priority = config.priority,
        sign_text = config.format and config.format(mark) or mark,
    })
end

function M.clear_ns(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

local function buf_draw_local_marks(bufnr)
    local buf_marks = vim.fn.getmarklist(bufnr)
    for _, mark in ipairs(buf_marks) do
        if config.filter(mark.mark) then
            local line = mark.pos[2] - 1
            local col = mark.pos[3] - 1
            set_mark_extmark(bufnr, mark.mark, line, col)
        end
    end
end

local function buf_draw_global_marks(bufnr)
    local glob_marks = vim.fn.getmarklist()
    for _, mark in ipairs(glob_marks) do
        if mark.pos[1] == bufnr then
            if config.filter(mark.mark) then
                local line = mark.pos[2] - 1
                local col = mark.pos[3] - 1
                set_mark_extmark(mark.pos[1], mark.mark, line, col)
            end
        end
    end
end

function M.refresh(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    M.clear_ns(bufnr)
    buf_draw_local_marks(bufnr)
    if not config.local_only then
        buf_draw_global_marks(bufnr)
    end
end

-- local function get_visible_bufs()
--     local bufs = {}
--     local wins = vim.api.nvim_tabpage_list_wins(0)
--     for _, winid in ipairs(wins) do
--         bufs[vim.api.nvim_win_get_buf(winid)] = true
--     end
--     return vim.tbl_keys(bufs)
-- end

local enabled = false
local function toggle()
    local bufnr = vim.api.nvim_get_current_buf()
    if enabled then
        enabled = false
        M.clear_ns(bufnr)
    else
        enabled = true
        M.refresh(bufnr)
    end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "ModeChanged" }, {
    callback = function(args)
        if enabled then
            M.refresh(args.buf)
        end
    end,
    desc = "Set marks extmarks",
})

vim.api.nvim_create_user_command("MarksToggle", toggle, {})

vim.keymap.set({ "n", "x" }, "m", function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local mark = vim.fn.getcharstr()
    vim.api.nvim_buf_set_mark(0, mark, line, col, {})
    if enabled then
        M.refresh()
    end
end)

return M

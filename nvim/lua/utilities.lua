local M = {}

function M.visual_selection_range()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
    if csrow < cerow or (csrow == cerow and cscol <= cecol) then
        return csrow - 1, cscol - 1, cerow - 1, cecol
    else
        return cerow - 1, cecol - 1, csrow - 1, cscol
    end
end

-- nvim_buf_get_text(buffer, start_row, start_col, end_row, end_col, opts)

return M

-- StatusLine {{{
local function setup_hl()
    local function gethl(hlname)
        return vim.api.nvim_get_hl(0, { name = hlname })
    end
    -- vim.api.nvim_set_hl(0, "StatusLine", { link = "StatusLineNC" } )
    vim.api.nvim_set_hl(0, "StatusLine", { link = "NormalFloat" } )
    vim.api.nvim_set_hl(0, "WinBar", { fg = gethl("Comment").fg, bg = gethl("NormalFloat").bg } )
    vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinBar" } )
    vim.api.nvim_set_hl(0, "LineNr", { fg = gethl("LineNr").fg, bg = gethl("NormalFloat").bg } )
    vim.api.nvim_set_hl(0, "SignColumn", { link = "LineNr" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = gethl("DiagnosticWarn").fg, bg = gethl("CursorLine").bg } )
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "NonText" } )
    vim.api.nvim_set_hl(0, "User1", { link = "DiagnosticError" } )
    vim.api.nvim_set_hl(0, "User2", { link = "Directory" } )
    vim.api.nvim_set_hl(0, "User3", { link = "DiagnosticOk" } )
    vim.api.nvim_set_hl(0, "User4", { link = "DiagnosticHint" } )
    vim.api.nvim_set_hl(0, "User5", { link = "DiagnosticWarn" } )
    vim.api.nvim_set_hl(0, "TabLine", { fg = gethl("NonText").fg, bg = gethl("NormalFloat").bg } )
    vim.api.nvim_set_hl(0, "TabLineSel", { fg = "fg", bg = gethl("NormalFloat").bg } )
    vim.api.nvim_set_hl(0, "TabLineFill", { link = "NormalFloat" } )
    vim.api.nvim_set_hl(0, "MsgArea", { link = "NormalFloat" })
end
setup_hl()

local augrp = vim.api.nvim_create_augroup("statusline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_hl, group = augrp })

vim.o.showcmdloc = "statusline"
local statusline = {
    "%#User1#%2{toupper(mode())}%* ",
    "%{% &modified ? '%#User5#' : '%#User4#' %}%f%s%q%w%*",
    "%#User3#%m%r%*%<",
    "%=",
    "%#User1#%{reg_recording() != '' ? '@' . reg_recording() . ' ' : ''}%*%S ",
    "%{v:hlsearch ? searchcount().current . '/' . searchcount().total . ' ' : ''}",
    "%#User4#%y%* ",
    "%#User3#%{ &fenc != 'utf-8' ? &fenc . ' ' : '' }%*",
    "%8(%l,%2c%V %)%P",
}
vim.o.laststatus = 3
vim.o.statusline = table.concat(statusline, "")


-- vim.o.winbar = "%#Normal#%=%=%* %f%#User3#%m%r%*%< "
vim.o.winbar = "%f%#User3#%m%r%*%< %#Normal#%=%*"
-- }}}

-- Tabline {{{
local BufList = { loaded_bufs = {}}
function BufList:get_bufs()
    self.loaded_bufs = vim.tbl_filter(function(bufnr)
        return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted
    end, vim.api.nvim_list_bufs()) 
end

vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
    callback = function(args)
        vim.schedule(function()
            BufList:get_bufs()
            if #BufList.loaded_bufs > 1 then
                vim.o.showtabline = 2
            else
                vim.o.showtabline = 0
            end
        end)
    end,
    group = augrp
})

function _G.tabline_switch_buf(minwid)
    vim.api.nvim_win_set_buf(0, minwid)
end

function TabLineBufList()
    local curbuf = vim.api.nvim_get_current_buf()
    local buflist = vim.tbl_map(function(bufnr)
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local name = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        modified = vim.bo[bufnr].modified and "%#User3#[+]%*" or ""
        name = "%" .. bufnr .. "@v:lua.tabline_switch_buf@" .. name .. modified .. "%X"
        local hl = bufnr == curbuf and "TabLineSel" or "TabLine"
        return string.format('%%#%s#%s%%*', hl, name)
    end, BufList.loaded_bufs)
    return table.concat(buflist, " ")
end

function TabLineTabList()
    local curtab = vim.api.nvim_get_current_tabpage()
    local tablist = vim.tbl_map(function(tabid)
        local hl = tabid == curtab and "TabLineSel" or "TabLine"
        local tabnr = vim.api.nvim_tabpage_get_number(tabid)
        return string.format("%%#%s#%%%dT%d%%X%%*", hl, tabid, tabnr)
    end, vim.api.nvim_list_tabpages())
    if #tablist <= 1 then return "" end
    return table.concat(tablist, " ") .. " %999XX%X"
end

vim.o.tabline = "%{%v:lua.TabLineBufList()%} %= %{%v:lua.TabLineTabList()%}"

vim.cmd([[au statusline FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
-- }}}

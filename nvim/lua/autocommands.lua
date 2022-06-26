local autocmd = vim.api.nvim_create_autocmd

local au_id = vim.api.nvim_create_augroup("MyAutoCommands", { clear = true })

-------------------------
--  Highlight On Yank  --
-------------------------

autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
    group = au_id,
})

--------------------------
--  Quickfix / Loclist  --
--------------------------

autocmd("FileType", {
    pattern = "qf",
    command = "set nobuflisted",
    group = au_id,
})

------------------------
--  Custom Filetypes  --
------------------------

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.cms", "*.mae" },
    command = "setlocal foldmarker={,} foldmethod=marker",
    group = au_id,
})

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.msj",
    command = "set filetype=config",
    group = au_id,
})

-----------------------------
--  FileType Autocommands  --
-----------------------------

autocmd("FileType", {
    pattern = "json",
    command = [[syntax match Comment +\/\/.\+$+]],
    group = au_id,
})

autocmd("FileType", {
    pattern = { "markdown", "pandoc" },
    command = [[setlocal makeprg=pandoc\ -f\ gfm\ --pdf-engine=xelatex\ %\ -o\ %:r.pdf]],
    group = au_id,
})

-----------------
--  Scrolloff  --
-----------------

autocmd("WinEnter", {
    command = [[let &l:scrolloff = winheight(0) / 3]],
    group = au_id,
})

-----------------------------------
--  CursorLine, RelativeNumbers  --
-----------------------------------

-- autocmd({ "WinEnter", "BufWinEnter" }, {
--     command = "setlocal cursorline relativenumber",
--     group = au_id,
-- })

autocmd({ "WinEnter", "BufWinEnter", "FileType" }, {
    callback = function(args)
        local buf = args.buf
        if not vim.tbl_contains({ "terminal", "prompt", "nofile" }, vim.bo[buf].buftype) then
            vim.cmd([[setl cursorline | let &l:relativenumber = &l:number]])
        -- else
        --     vim.cmd([[setl nocursorline | let &l:relativenumber = &l:number]])
        end
    end,
    group = au_id,
})

autocmd("WinLeave", {
    command = "setlocal nocursorline norelativenumber",
    group = au_id,
})
-- autocmd("FileType", {})

----------------
--  Terminal  --
----------------

autocmd("TermOpen", {
    callback = function(args)
        vim.cmd([[setlocal nonumber norelativenumber winhl=Normal:NormalFloat]])
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
        end
    end,
    group = au_id,
})
autocmd({ "WinEnter", "BufWinEnter" }, {
    command = [[ if &buftype == 'terminal' | startinsert | endif ]],
    group = au_id,
})

-- autocmd FileType latex,tex,markdown,txt setlocal spell
-- autocmd FileType latex,tex,markdown,txt,text setlocal wrap
-- autocmd BufWrite *.md :! pandoc -f gfm -t html -o /tmp/%:t.html %
-- autocmd User DiagnosticsChanged lua vim.diagnostic.setqflist({open = false })

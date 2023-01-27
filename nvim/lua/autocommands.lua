local au_id = vim.api.nvim_create_augroup("MyAutoCommands", { clear = true })

local autocmd = function(pattern, opts)
    opts.group = au_id
    vim.api.nvim_create_autocmd(pattern, opts)
end

-------------------------
--  Highlight On Yank  --
-------------------------

autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
    end,
})

--------------------------
--  Quickfix / Loclist  --
--------------------------

autocmd("FileType", {
    pattern = "qf",
    command = "set nobuflisted",
})

------------------------
--  Custom Filetypes  --
------------------------

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.cms", "*.mae" },
    command = "setlocal foldmarker={,} foldmethod=marker",
})

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.msj",
    command = "set filetype=config",
})

-----------------------------
--  FileType Autocommands  --
-----------------------------

autocmd("FileType", {
    pattern = "json",
    command = [[syntax match Comment +\/\/.\+$+]],
})

autocmd("FileType", {
    pattern = { "markdown", "pandoc" },
    command = [[setlocal makeprg=pandoc\ -f\ gfm\ --pdf-engine=xelatex\ %\ -o\ %:r.pdf]],
})

autocmd("Filetype", {
    pattern = "rust",
    callback = function(args)
        vim.api.nvim_buf_create_user_command(args.buf, "CargoFix", "! cd %:p:h && cargo fix", {})
    end,
})

-----------------
--  Scrolloff  --
-----------------

autocmd({ "WinEnter", "BufWinEnter" }, {
    command = [[let &l:scrolloff = winheight(0) / 3]],
})

------------------------
--  Better WinClosed  --
------------------------

autocmd("WinClosed", {
    command = 'if win_getid() == expand("<amatch>") | wincmd p | endif',
})

-----------------------------------
--  CursorLine, RelativeNumbers  --
-----------------------------------

-- autocmd({ "WinEnter", "BufWinEnter" }, {
--     command = "setlocal cursorline relativenumber",
-- })

autocmd({ "WinEnter", "BufWinEnter", "FileType" }, {
    callback = function(args)
        local buf = args.buf
        if not vim.tbl_contains({ "terminal", "prompt", "nofile" }, vim.bo[buf].buftype) then
            vim.cmd([[setl cursorline | let &l:relativenumber = &l:number]])
        else
            vim.cmd([[setl nocursorline | let &l:relativenumber = &l:number | setl signcolumn=no]])
        end
    end,
})

autocmd("WinLeave", {
    command = "setlocal nocursorline norelativenumber",
})

--------------
--  CmdWin  --
--------------

autocmd("CmdwinEnter", {
    command = "startinsert | setlocal nonu nornu cul syntax=on signcolumn=no stc= winbar= winhl=Normal:NormalFloat",
})

----------------
--  Terminal  --
----------------

autocmd("TermOpen", {
    callback = function(args)
        vim.bo.ft = "terminal"
        vim.cmd([[setlocal nonumber norelativenumber winhl=Normal:NormalFloat]])
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
        end
    end,
})
autocmd({ "WinEnter", "BufWinEnter" }, {
    command = [[ if &buftype == 'terminal' | startinsert | endif ]],
})

-------------
--  Folds  --
-------------

-- fix for Telescope #699
-- autocmd("BufWinEnter", {
--     command = 'normal! zx',
-- })

-----------
--  LSP  --
-----------

autocmd("LSPAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        vim.notify(
            string.format("%s(%d) attached to buffer(%d)", client.name, client.id, bufnr),
            vim.log.levels.INFO,
            { title = "LSP" }-- requires nvim-notify
        )
    end,
})

-- autocmd FileType latex,tex,markdown,txt setlocal spell
-- autocmd FileType latex,tex,markdown,txt,text setlocal wrap
-- autocmd BufWrite *.md :! pandoc -f gfm -t html -o /tmp/%:t.html %
-- autocmd User DiagnosticsChanged lua vim.diagnostic.setqflist({open = false })

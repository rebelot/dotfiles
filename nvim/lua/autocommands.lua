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

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.rs", "Cargo.toml" },
    callback = function(args)
        vim.cmd("compiler cargo")
    end,
})

-----------------
--  Scrolloff  --
-----------------

autocmd({ "WinEnter", "BufWinEnter" }, {
    command = [[let &l:scrolloff = winheight(0) / 4]],
})

------------------------
--  Better WinClosed  --
------------------------

autocmd("WinClosed", {
    command = 'if win_getid() == expand("<amatch>") | wincmd p | endif',
    nested = true,
})

-----------------------------------------------
--  CursorLine, RelativeNumbers, SignColumn  --
-----------------------------------------------

autocmd({ "WinEnter", "BufWinEnter", "FileType", "BufEnter" }, {
    callback = function(args)
        local buf = args.buf
        if vim.tbl_contains({ "terminal", "prompt", "nofile", "help" }, vim.bo[buf].buftype) then
            vim.cmd([[setl nocursorline | setl signcolumn=no | let &l:relativenumber = &l:number]])
        end
        -- if vim.tbl_contains({ "NvimTree" }, vim.bo[buf].filetype) then
        --     vim.cmd([[setl cursorline | setl signcolumn=yes:1 | let &l:relativenumber = &l:number]])
        -- end
        if vim.bo[buf].buftype == "" then
            vim.cmd([[setl cursorline | let &l:relativenumber = &l:number]])
        end
        if vim.bo[buf].buftype == "quickfix" then
            vim.cmd([[setl cursorline nonu signcolumn=no | let &l:relativenumber = &l:number]])
        end
        if vim.bo[buf].filetype == "trouble" then
            vim.cmd([[setl cursorline nonu signcolumn=no | let &l:relativenumber = &l:number]])
        end
    end,
})

autocmd("WinLeave", {
    -- command = "setlocal nocursorline norelativenumber",
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end
        if vim.wo.scrollbind then
            return
        end
        vim.cmd([[setlocal nocursorline norelativenumber]])
    end,
})

--------------
--  CmdWin  --
--------------

autocmd("CmdwinEnter", {
    command = "startinsert | setlocal nonu nornu cul syntax=on signcolumn=no stc= winbar= winhl=Normal:NormalDark",
})

----------------
--  QuickFix  --
----------------

autocmd("BufWinEnter", {
    callback = function(args)
        local buf = args.buf
        if vim.bo[buf].buftype == "quickfix" then
            vim.cmd([[setl winhl=Normal:NormalDark]])
            vim.keymap.set("n", "q", "<cmd>cclose<CR>", { buffer = buf })
            vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zt<C-w>p", { buffer = buf })
            vim.keymap.set("n", "<C-p>", "<cmd>cNext<CR>zt<C-w>p", { buffer = buf })
            vim.keymap.set("n", "<C-CR>", "<CR>zt<C-w>p", { buffer = buf })
        end
    end,
})

autocmd("QuickFixCmdPost", {
    command = "cwindow",
    nested = true,
})
----------------
--  Terminal  --
----------------

autocmd("TermOpen", {
    callback = function(args)
        vim.bo.ft = "terminal"
        vim.cmd([[setlocal nonumber norelativenumber winhl=Normal:NormalDark]])
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
            { title = "LSP" } -- requires nvim-notify
        )
    end,
})

-- autocmd FileType latex,tex,markdown,txt setlocal spell
-- autocmd FileType latex,tex,markdown,txt,text setlocal wrap
-- autocmd BufWrite *.md :! pandoc -f gfm -t html -o /tmp/%:t.html %
-- autocmd User DiagnosticsChanged lua vim.diagnostic.setqflist({open = false })

-- Options {{{
vim.o.undofile = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = vim.o.shiftwidth
-- vim.o.completeopt = "menuone,popup,longest,fuzzy"
vim.o.completeopt = "menuone,popup,fuzzy,noselect"
vim.o.wildmode = "longest:full,longest,lastused"
vim.o.number = true
vim.o.wrap = false
vim.o.relativenumber = vim.o.number
vim.o.cursorline = true
vim.o.cmdheight = 0
vim.o.foldtext = ""
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldmethod = 'indent'
vim.o.grepprg = 'ag --vimgrep'
-- }}}

require("mappings")
require("autocommands")
require("statusline")
require("diagnostics")
-- vim: fdm=marker

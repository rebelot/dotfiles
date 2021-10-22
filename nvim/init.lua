
-- ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
-- ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
-- ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
-- ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
-- ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
-- ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

-- TODO:
-- try  sindrets/winshift.nvim
-- try nvim which-key
-- check out vim.quickui
-- folke/todo-comments.nvim
-- try null-lsp

-- Plugins
require "plugins"

-- Colors
require "colors"

-- general configurations
require "options"

-- Diagnostics
require "diagnostics"

-- LSP
require "lsp-config"

-- Functions, Commands, Autocommands
vim.cmd "source ~/.config/nvim/viml/commands.vim"
vim.cmd "source ~/.config/nvim/viml/autocommands.vim"

-- Mappings
vim.cmd "source ~/.config/nvim/viml/mappings.vim"

-- vim: sw=2 ts=2 fdm=marker:


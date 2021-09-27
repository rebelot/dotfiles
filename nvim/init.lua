
-- ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
-- ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
-- ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
-- ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
-- ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
-- ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

local vim = vim

-- TODO:
-- 2) expose LSPFormat command
-- 3) try  sindrets/winshift.nvim
-- 4) try nvim which-key

-- Plugins
require "plugins"

-- Colors
require "colors"

-- general configurations
require "options"

-- LSP
require "lsp-config"

-- Functions, Commands, Autocommands
vim.cmd "source ~/.config/nvim/viml/commands.vim"
vim.cmd "source ~/.config/nvim/viml/autocommands.vim"

-- Mappings
vim.cmd "source ~/.config/nvim/viml/mappings.vim"

-- vim: sw=2 ts=2 fdm=marker:


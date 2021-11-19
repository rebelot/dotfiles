
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

-- Plugins
require "plugins"

-- Colors
require"colors".tokyonight()
-- require"colors".catppuccin()
require"colors".overrides()

-- general configurations
require "options"

-- Diagnostics
require "diagnostics"

-- Functions, Commands, Autocommands
vim.cmd "source ~/.config/nvim/viml/commands.vim"
vim.cmd "source ~/.config/nvim/viml/autocommands.vim"

-- Mappings
vim.cmd "source ~/.config/nvim/viml/mappings.vim"

-- vim: sw=2 ts=2 fdm=marker:


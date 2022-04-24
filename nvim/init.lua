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
-- dashboard -> goolord/alpha-nvim.git
-- check telescope project for bookmarks
-- maybe it's time for a session plugin
-- play with foldtext function to customize it
-- check out sidebar-nvim/sidebar.nvim

require("impatient")

-- Plugins
require("plugins")

--
vim.opt.laststatus = 3
require("colors").kanagawa()

-- general configurations
require("options")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/commands.vim")
vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")

-- Diagnostics
require("diagnostics")

-- UI
require("win_ui_input")

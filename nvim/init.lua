-- ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
-- ██║████╗  ██║██║╚══██╔══╝██║     ██║   ██║██╔══██╗
-- ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
-- ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
-- ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
-- ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝

-- TODO:
-- try  sindrets/winshift.nvim
-- check out vim.quickui
-- folke/todo-comments.nvim
-- check telescope project for bookmarks
-- maybe it's time for a session plugin
-- check out sidebar-nvim/sidebar.nvim

vim.loader.enable()

-- general configurations
require("options")

-- Plugins
require("plugins")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/commands.vim")
require("autocommands")
-- vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")

-- Diagnostics
require("diagnostics-config")

-- UI
require("win_ui_input")

-- Other
require("grep")
-- require("marks")
require("searchyank")
require("session")
require("hex")

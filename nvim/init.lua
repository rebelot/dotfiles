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
-- switch from packer to folke/lazy.nvim

-- require("impatient")--.enable_profile()

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")

-- Plugins
require("plugins")

--
vim.opt.laststatus = 3
-- require("colors")

-- general configurations
require("options")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/commands.vim")
require("autocommands")
-- vim.cmd("source ~/.config/nvim/viml/autocommands.vim")


-- Diagnostics
require("diagnostics-config")

-- UI
require("win_ui_input")

-- Other
require("grep")
require("marks")
require("searchyank")


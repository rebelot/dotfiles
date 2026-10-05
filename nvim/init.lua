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
-- {"folke/flash.nvim"}
-- check out sidebar-nvim/sidebar.nvim
-- check gbprod/yanky.nvim
-- vim.loader.enable()

require("vim._core.ui2").enable({ enable = true, msg = { targets = "msg" } })

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

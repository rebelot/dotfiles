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

-- Plugins
require("plugins")

--
require'kanagawa'.setup({
  dimInactive = true
})
vim.cmd("colorscheme kanagawa")
require("colors").overrides()

-- general configurations
require("options")

-- Diagnostics
require("diagnostics")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/commands.vim")
vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")

-- vim: sw=2 ts=2 fdm=marker:

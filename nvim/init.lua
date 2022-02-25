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
-- require("kanagawa").setup({
--     dimInactive = true,
-- })
vim.cmd("colorscheme kanagawa")
require("colors").overrides()

-- function _G.filebuftypes_au(filebuftypes)
--     local bt = vim.bo.buftype
--     local ft = vim.bo.filetype
--     if vim.tbl_contains(filebuftypes.filetypes, ft) or vim.tbl_contains(filebuftypes.buftypes, bt) then
--         vim.cmd([[set winhighlight=Normal:NormalFloat]])
--     end
-- end
--
vim.cmd([[
augroup FileTypeHighlight
  autocmd!
  au FileType git*,dap*,vista_kind,tagbar,fugitive set winhighlight=Normal:NormalFloat
augroup END
]])

-- general configurations
require("options")

-- Diagnostics
require("diagnostics")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/commands.vim")
vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")

local tree_cb = require'nvim-tree.config'.nvim_tree_callback


vim.g.nvim_tree_show_icons = {
        git                = 1,
        folders            = 1,
        files              = 1,
        folder_arrows      = 1,
}

vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "✗",
    staged = "✓",
    unmerged = "",
    renamed = "➜",
    untracked = "★",
    deleted = "",
    ignored = "◌"
  },
  folder = {
    arrow_open = "",
    arrow_closed = "",
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = ""
  },
  lsp = {
    hint= "",
    info= "",
    warning= "",
    error= "",
    }
}

-- vim.g.nvim_tree_ignore                 = {".git", "node_modules", ".cache"}
vim.g.nvim_tree_gitignore              = 1
vim.g.nvim_tree_auto_ignore_ft         = {} -- don't open tree on specific fiypes.
vim.g.nvim_tree_quit_on_open           = 0 -- closes tree when file's opened
vim.g.nvim_tree_indent_markers         = 0
-- vim.g.nvim_tree_hide_dotfiles          = 0
vim.g.nvim_tree_respect_buf_cwd        = 0
vim.g.nvim_tree_git_hl                 = 1
vim.g.nvim_tree_highlight_opened_files = 1 -- 3
vim.g.nvim_tree_root_folder_modifier   = table.concat {":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??"}
vim.g.nvim_tree_allow_resize           = 1
vim.g.nvim_tree_add_trailing           = 1 -- append a trailing slash to folder names

require'nvim-tree'.setup{
      disable_netrw       = false,
      hijack_netrw        = true,
      open_on_setup       = false,
      ignore_ft_on_setup  = {},
      auto_close          = false,
      open_on_tab         = false,
      hijack_cursor       = true,
      update_cwd          = false,
      hide_dotfiles       = false,
      -- ignore  = {".git", "node_modules", ".cache"},
      diagnostics         = {enable  = false},
      update_focused_file = {
        enable      = true,
        update_cwd  = false,
        ignore_list = {}
      },
      system_open = {
        cmd  = nil,
        args = {}
      },
}


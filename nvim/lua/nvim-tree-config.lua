local g = vim.g
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
g.nvim_tree_gitignore = 1
g.nvim_tree_auto_ignore_ft = {} -- don't open tree on specific fiypes.
g.nvim_tree_auto_open = 0
g.nvim_tree_auto_close = 0 -- closes tree when it's the last window
g.nvim_tree_quit_on_open = 0 -- closes tree when file's opened
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 0
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_root_folder_modifier = table.concat {":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??"}
g.nvim_tree_tab_open = 0
g.nvim_tree_allow_resize = 1
g.nvim_tree_add_trailing = 1 -- append a trailing slash to folder names
g.nvim_tree_disable_netrw = 0
g.nvim_tree_hijack_netrw = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_update_cwd = 0
g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
}

g.nvim_tree_icons = {
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

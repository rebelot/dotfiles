local tree_cb = require("nvim-tree.config").nvim_tree_callback

vim.g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 1,
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
        ignored = "◌",
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = "",
    },
}

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1 -- 3
vim.g.nvim_tree_root_folder_modifier = table.concat({ ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" })
vim.g.nvim_tree_allow_resize = 1
vim.g.nvim_tree_add_trailing = 1 -- append a trailing slash to folder names

require("nvim-tree").setup({
    disable_netrw = false,
    hijack_netrw = true,
    hijack_cursor = true,
    update_cwd = true,
    filters = {
        dotfiles = false,
    },
    diagnostics = { enable = false },
    git = { enable = true, ignore = true },

    update_focused_file = {
        enable = true,
        update_cwd = false,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    actions = {
        change_dir = {
            global = true
        },
        open_file = {
            resize_window = true
        }
    }
})

vim.keymap.set("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: toggle" })
vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", { desc = "NvimTree: find file" })

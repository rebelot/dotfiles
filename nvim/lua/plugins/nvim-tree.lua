local tree_cb = require("nvim-tree.config").nvim_tree_callback

-- vim.g.nvim_tree_allow_resize = 1

require("nvim-tree").setup({
    disable_netrw = false,
    hijack_netrw = true,
    hijack_cursor = true,
    respect_buf_cwd = false,
    sync_root_with_cwd = true,
    filters = {
        dotfiles = false,
    },
    diagnostics = { enable = false },
    git = { enable = true, ignore = true },

    update_focused_file = {
        enable = false,
        update_root = true,
        ignore_list = {"help"},
    },
    live_filter = {
        always_show_folders = false
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    actions = {
        change_dir = {
            global = true,
        },
        open_file = {
            resize_window = true,
        },
    },
    view = {
        adaptive_size = false,
    },
    renderer = {
        icons = {
            git_placement = "before",
            glyphs = {
                git = {
                    unstaged = "",
                    staged = "",
                    unmerged = "",
                    renamed = "",
                    untracked = "",
                    deleted = "",
                    ignored = "",
                },
            },
        },
    },
})

vim.keymap.set("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: toggle" })
vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile!<CR>", { desc = "NvimTree: find file" })

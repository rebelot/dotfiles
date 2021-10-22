local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

require('telescope').setup {
    defaults = {
        dynamic_preview_title = true,
        layout_strategy = 'flex',
        layout_config = {
            vertical = {
                preview_height = 0.5
            },
            flex = {
                flip_columns = 160
            },
            horizontal = {
                preview_width = .5
            },
            height = 0.85,
            width = 0.85,
            preview_cutoff = 0
        },
        file_ignore_patterns = {"node_modules", ".git"},
        path_display = {
            truncate = 1
        },
        set_env = {
            ["COLORTERM"] = "truecolor"
        }, -- default = nil,
        -- file_previewer = previewers.cat.new,
        grep_previewer = previewers.vimgrep.new,
        qflit_previewer = previewers.qflist.new,
        history = {
            mappings = {
                i = {
                    ["<C-Down>"] = actions.cycle_history_next,
                    ["<C-Up>"] = actions.cycle_history_prev
                }
            }
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Tab>"] = actions.move_selection_previous,
                ["<S-Tab>"] = actions.move_selection_next,
                ["<C-z>"] = actions.toggle_selection,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist
            },
            n = {
                ["<C-z>"] = actions.toggle_selection,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist
            }
        }
    },
    pickers = {
        find_files = {
            follow = true
        },
        file_browser = {
            hidden = true,
            depth = 2
        },
        buffers = {
            sort_mru = true,
            mappings = {
                i = {
                    ["<C-r>"] = actions.delete_buffer
                },
                n = {
                    ["<C-r>"] = actions.delete_buffer
                }
            }
        }
    }
}

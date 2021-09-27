local actions = require('telescope.actions')
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case"
    },
    selection_caret = '> ',
    layout_strategy = 'flex',
    layout_config = {
      vertical = {
        preview_height = 0.5,
      },
      flex = {
        flip_columns = 130,
      },
      preview_cutoff = 40,
      height = 0.99,
      width = 0.8
    },
    file_ignore_patterns = {"node_modules", ".git"},
    path_display = {"absolute"},
    set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Tab>"] = actions.move_selection_next,
        ["<S-Tab>"] = actions.move_selection_previous,
        ["<C-z>"] = actions.toggle_selection,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-z>"] = actions.toggle_selection,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = actions.send_selected_to_qflist + actions.open_qflist,
      }
    },
  },
  pickers = {
    find_files = {
      follow = true
    },
    file_browser = {
      hidden = true
    },
    buffers = {
      mappings = {
        i = {
          ["<C-r>"] = actions.delete_buffer,
        },
        n = {
          ["<C-r>"] = actions.delete_buffer,
        },
      }
    }
  }
}

local vim = vim

require("lualine").setup {
  options = {
    theme = "tokyonight",
    icons_enabled = true,
    --      
    -- section_separators = {"", ""},
    -- component_separators = {"", ""}

    -- section_separators = {'', ''},

    -- section_separators = {'', ''},
    -- component_separators = {"", ""},
    section_separators = {'', ''},
    -- component_separators = {'', ''}
    -- section_separators = {'', ''},
    component_separators = {'', ''}
  },
  sections = {
    lualine_a = {{"mode", separator = {"CULO", "CUOL"}}},
    -- lualine_b = {"branch", "diff"},
    lualine_b = {{"b:gitsigns_head", icon = ''}, "b:gitsigns_status"},
    lualine_c = {{"filename", file_status = true, path = 1},
        {"diagnostics",
            sources = {"nvim_lsp"},
            symbols = {error = " ", warn = " ", info = " ", hint = " "},
            color_error = '#fb4934',
            color_warn = '#fabd2f',
            color_info = '#83a598',
            color_hint = '#8ec07c',
        }, require'lsp-status'.status,
    },
    lualine_x = {'encoding', 'fileformat', "filetype"},
    lualine_y = {},
    lualine_z = {"progress", "location"}

  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {"nvim-tree", 'quickfix', 'fugitive', 'fzf'}
}

require'lsp-status'.config{
  -- kind_labels = {},
  current_function = true,
  diagnostics = false,
  indicator_separator = '',
  component_separator = ' ',
  indicator_errors = ' ',
  indicator_warnings = ' ',
  indicator_info = ' ',
  indicator_hint = ' ',
  indicator_ok = ' ',
  spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
  status_symbol = '',
  select_symbol = nil,
  -- select_symbol = function(cursor_pos, symbol)
  --   if symbol.valueRange then
  --     local value_range = {
  --       ["start"] = {
  --         character = 0,
  --         line = vim.fn.byte2line(symbol.valueRange[1])
  --       },
  --       ["end"] = {
  --         character = 0,
  --         line = vim.fn.byte2line(symbol.valueRange[2])
  --       }
  --     }
  --     return require("lsp-status.util").in_range(cursor_pos, value_range)
  --   end
  -- end,
  update_interval = 100
}

local function shorten_path(path)
    return path:gsub("(/.)[^/]*", "%1")
end

local vim = vim

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

require("lualine").setup {
  options = {
    theme = "gruvbox",
    icons_enabled = true,
    -- section_separators = {"", ""},
    -- component_separators = {"", ""}

    section_separators = {'', ''},
    --    
    -- section_separators = {'', ''},
    component_separators = {"", ""}
  },
  sections = {
    lualine_a = {"mode"},
    -- lualine_b = {"branch", "diff"},
    lualine_b = {{"b:gitsigns_head", icon = ''}, "b:gitsigns_status"},
    lualine_c = {{"filename", file_status = true, path = 1},
        {"diagnostics",
            sources = {"nvim_lsp"},
            symbols = {error = "", warn = "", info = "", hint = ""},
            color_error = '#fb4934',
            color_warn = '#fabd2f',
            color_info = '#83a598',
            color_hint = '#8ec07c',
        }, require'lsp-status'.status,
    },
    lualine_x = {'encoding', 'fileformat', "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}

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

local function shorten_path(path)
    return path:gsub("(/.)[^/]*", "%1")
end

require("bufferline").setup(
  {
    options = {
      numbers = function(opts) return opts.id .. '.' end,
      max_name_length = 30,
      right_mouse_command = "vertical sbuffer %d",
      -- name_formatter = function(buf)
      --   return shorten_path(buf.path)
      -- end,
      show_close_icon = false,
      diagnostics = false,
      always_show_bufferline = true,
      modified_icon = '',
      left_trunc_marker = "<",
      right_trunc_marker = ">",
      separator_style = "slant",
      offsets = {{filetype = "NvimTree"}, {filetype = 'Vista'}},
      diagnostics_indicator = function(_, _, diagnostics_dict)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or "")
          s = s .. sym .. n
        end
        return s
      end
    },
    -- custom_filter = function(buf_number)
    --   -- filter out filetypes you don't want to see
    --   if vim.bo[buf_number].filetype ~= "qf" then
    --     return true
    --   end
    --   if vim.bo[buf_number].filetype ~= '' then
    --       return false
    --     end
    -- end,
    highlights = {
        fill = {guibg = {attribute = 'bg', highlight = 'Normal'}},
        separator = {guifg = {attribute = "bg", highlight = 'Normal'}},
        separator_selected = {guifg = {attribute = "bg", highlight = 'Normal'}},
        separator_visible = {guifg = {attribute="bg", highlight='Normal'}},
    }
  }
)

require("bufferline").setup({
    options = {
        -- numbers = function(opts)
        --     return opts.id .. "."
        -- end,
        max_name_length = 30,
        right_mouse_command = "vertical sbuffer %d",
        -- name_formatter = function(buf)
        --   return shorten_path(buf.path)
        -- end,
        show_close_icon = false,
        diagnostics = false,
        always_show_bufferline = true,
        modified_icon = "[+]",
        left_trunc_marker = "<",
        right_trunc_marker = ">",
        separator_style = "slant",
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" }, { filetype = "Vista" } },
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
        fill = { bg = { attribute = "bg", highlight = "Normal" } },
        separator = { fg = { attribute = "bg", highlight = "Normal" } },
        separator_selected = { fg = { attribute = "bg", highlight = "Normal" } },
        separator_visible = { fg = { attribute = "bg", highlight = "Normal" } },
    },
})

require'lsp-status'.config {
    -- kind_labels = {},
    current_function = false,
    diagnostics = false,
    indicator_separator = '',
    component_separator = '',
    indicator_errors = ' ',
    indicator_warnings = ' ',
    indicator_info = ' ',
    indicator_hint = ' ',
    indicator_ok = ' ',
    spinner_frames = {
        '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'
    },
    -- status_symbol = '[LSP] ',
    status_symbol = '',
    -- select_symbol = nil,
    select_symbol = function(cursor_pos, symbol)
        if symbol.valueRange then
            local value_range = {
                ["start"] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[1])
                },
                ["end"] = {
                    character = 0,
                    line = vim.fn.byte2line(symbol.valueRange[2])
                }
            }
            return require("lsp-status.util").in_range(cursor_pos, value_range)
        end
    end,
    update_interval = 100
}

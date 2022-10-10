require("indent_blankline").setup {
    buftype_exclude = {"terminal", "prompt", "nofile"},
    filetype_exclude = {
        'help', 'dashboard', 'Trouble', 'dap.*', 'NvimTree',
        "packer"
    },
    show_current_context = true,
    show_current_context_start = false,
    show_trailing_blankline_indent = false,
    -- use_treesitter = true,
    -- use_treesitter_scope = true
    -- context_patterns = {
    --     'class', 'func', 'method', '.*_statement', 'table'
    -- }
}

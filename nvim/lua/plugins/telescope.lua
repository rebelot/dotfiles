local map = vim.keymap.set
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
-- local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
local trouble = require("trouble.sources.telescope")
local transform_mod = require("telescope.actions.mt").transform_mod

local function multiopen(prompt_bufnr, method)
    local edit_file_cmd_map = {
        vertical = "vsplit",
        horizontal = "split",
        tab = "tabedit",
        default = "edit",
    }
    local edit_buf_cmd_map = {
        vertical = "vert sbuffer",
        horizontal = "sbuffer",
        tab = "tab sbuffer",
        default = "buffer",
    }
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if #multi_selection > 1 then
        require("telescope.pickers").on_close_prompt(prompt_bufnr)
        pcall(vim.api.nvim_set_current_win, picker.original_win_id)

        for i, entry in ipairs(multi_selection) do
            local filename, row, col

            if entry.path or entry.filename then
                filename = entry.path or entry.filename

                row = entry.row or entry.lnum
                col = vim.F.if_nil(entry.col, 1)
            elseif not entry.bufnr then
                local value = entry.value
                if not value then
                    return
                end

                if type(value) == "table" then
                    value = entry.display
                end

                local sections = vim.split(value, ":")

                filename = sections[1]
                row = tonumber(sections[2])
                col = tonumber(sections[3])
            end

            local entry_bufnr = entry.bufnr

            if entry_bufnr then
                if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
                    vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
                end
                local command = i == 1 and "buffer" or edit_buf_cmd_map[method]
                pcall(vim.cmd, string.format("%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)))
            else
                local command = i == 1 and "edit" or edit_file_cmd_map[method]
                if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
                    filename = require("plenary.path"):new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
                    pcall(vim.cmd, string.format("%s %s", command, filename))
                end
            end

            if row and col then
                pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
            end
        end
    else
        actions["select_" .. method](prompt_bufnr)
    end
end

local custom_actions = transform_mod({
    multi_selection_open_vertical = function(prompt_bufnr)
        multiopen(prompt_bufnr, "vertical")
    end,
    multi_selection_open_horizontal = function(prompt_bufnr)
        multiopen(prompt_bufnr, "horizontal")
    end,
    multi_selection_open_tab = function(prompt_bufnr)
        multiopen(prompt_bufnr, "tab")
    end,
    multi_selection_open = function(prompt_bufnr)
        multiopen(prompt_bufnr, "default")
    end,
})

local function stopinsert(callback)
    return function(prompt_bufnr)
        vim.cmd.stopinsert()
        vim.schedule(function()
            callback(prompt_bufnr)
        end)
    end
end

local multi_open_mappings = {
    i = {
        ["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
        ["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
        ["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
        ["<CR>"] = stopinsert(custom_actions.multi_selection_open),
    },
    n = {
        ["<C-v>"] = custom_actions.multi_selection_open_vertical,
        ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
        ["<C-t>"] = custom_actions.multi_selection_open_tab,
        ["<CR>"] = custom_actions.multi_selection_open,
    },
}

local symbol_highlights = {
    -- builtin
    Class = "TelescopeResultsClass",
    Constant = "TelescopeResultsConstant",
    Field = "TelescopeResultsField",
    Function = "TelescopeResultsFunction",
    Method = "TelescopeResultsMethod",
    Property = "TelescopeResultsOperator",
    Struct = "TelescopeResultsStruct",
    Variable = "TelescopeResultsVariable",
    -- lua
    String = "String",
    Boolean = "Constant",
    Package = "Keyword",
    Object = "Type",
    Number = "Number",
    Array = "@enum",
    -- Other Kinds
    Module = "PreProc",
    Interface = "@interface",
    Operator = "@operator",
    Enum = "@enum",
    -- Constructor = "",
    -- Color = "",
    -- EnumMember = "",
    -- Event = "",
    -- File = "",
    -- Folder = "",
    -- Keyword = "",
    -- Reference = "",
    -- Snippet = "",
    -- Text = "",
    -- TypeParameter = "",
    -- Unit = "",
    -- Value = "",
}

require("telescope").setup({
    defaults = {
        -- dynamic_preview_title = true,
        -- borderchars = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        layout_strategy = "flex",
        cycle_layout_list = { "horizontal", "vertical" },
        layout_config = {
            vertical = {
                preview_height = 0.5,
            },
            flex = {
                flip_columns = 160,
            },
            horizontal = {
                preview_width = 0.5,
            },
            height = 0.85,
            width = 0.85,
            preview_cutoff = 0,
        },
        file_ignore_patterns = { "node_modules", "%.git" },
        path_display = {
            truncate = 1,
        },
        set_env = {
            ["COLORTERM"] = "truecolor",
        }, -- default = nil,
        -- file_previewer = previewers.cat.new,
        -- grep_previewer = previewers.vim_buffer_vimgrep.new,
        -- qflist_previewer = previewers.qflist.new,
        -- history = {},
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Tab>"] = actions.move_selection_next,
                ["<S-Tab>"] = actions.move_selection_previous,
                ["<C-z>"] = actions.toggle_selection,
                ["<C-x>"] = trouble.get,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    require("trouble").open("loclist")
                end,
                ["<M-a>"] = actions.toggle_all,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<M-right>"] = actions_layout.cycle_layout_next,
                ["<M-left>"] = actions_layout.cycle_layout_prev,
                ["<C-o>"] = actions_layout.toggle_preview,
                ["<C-v>"] = stopinsert(custom_actions.multi_selection_open_vertical),
                ["<C-s>"] = stopinsert(custom_actions.multi_selection_open_horizontal),
                ["<C-t>"] = stopinsert(custom_actions.multi_selection_open_tab),
                ["<CR>"] = stopinsert(custom_actions.multi_selection_open),
            },
            n = {
                ["<Tab>"] = actions.move_selection_next,
                ["<S-Tab>"] = actions.move_selection_previous,
                ["<C-z>"] = actions.toggle_selection,
                ["<C-x>"] = trouble.get,
                ["<M-a>"] = actions.toggle_all,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    require("trouble").open("loclist")
                end,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<M-right>"] = actions_layout.cycle_layout_next,
                ["<M-left>"] = actions_layout.cycle_layout_prev,
                ["<C-o>"] = actions_layout.toggle_preview,
                ["<C-v>"] = custom_actions.multi_selection_open_vertical,
                ["<C-s>"] = custom_actions.multi_selection_open_horizontal,
                ["<C-t>"] = custom_actions.multi_selection_open_tab,
                ["<CR>"] = custom_actions.multi_selection_open,
            },
        },
    },
    pickers = {
        find_files = {
            follow = true,
        },
        buffers = {
            sort_mru = true,
        },
        spell_suggest = themes.get_cursor(),
        lsp_workspace_symbols = {
            symbol_highlights = symbol_highlights,
        },
        lsp_document_symbols = {
            symbol_highlights = symbol_highlights,
        },
        commands = themes.get_dropdown(),
    },
    extensions = {
        file_browser = {
            hidden = true,
            -- depth = 3,
            mappings = {
                i = {
                    ["<CR>"] = custom_actions.multi_selection_open,
                },
            },
        },
        ["ui-select"] = themes.get_dropdown(),
    },
})

map("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope: Find files" })
map(
    "n",
    "<leader>fl",
    require("telescope.builtin").current_buffer_fuzzy_find,
    { desc = "Telescope: Find current buffer" }
)
map("n", "<leader>fq", require("telescope.builtin").quickfix, { desc = "Telescope: Quickfix" })
map("n", "<leader>fh", require("telescope.builtin").oldfiles, { desc = "Telescope: Old files" })
map("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope: Buffers" })
map("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope: Live Grep" })
map("x", "<leader>fg", require("telescope.builtin").grep_string, { desc = "Telescope: Live Grep" })
map("n", "<leader>fG", function()
    require("telescope.builtin").live_grep({ grep_open_files = true })
end, { desc = "Telescope: Live Grep open_files" })
map("n", "<leader><space>", require("telescope.builtin").commands, { desc = "Telescope: Commands" })
map("n", "<leader>ft", require("telescope.builtin").treesitter, { desc = "Telescope: Treesitter" })
map("n", "<leader>fj", require("telescope.builtin").jumplist, { desc = "Telescope: Jump list" })
map("n", "<leader>k", require("telescope.builtin").keymaps, { desc = "Telescope: Keymaps" })
map("n", "<leader>T", function()
    require("telescope.builtin").builtin({ include_extensions = true })
end, { desc = "Telescope: List pickers" })
map("n", "<leader>z", require("telescope.builtin").spell_suggest, { desc = "Telescope: Spell suggestions" })
map("n", "<leader>fm", require("telescope.builtin").marks, { desc = "Telescope: Marks" })
map("n", '<leader>t"', require("telescope.builtin").registers, { desc = "Telescope: Registers" })

vim.api.nvim_create_user_command("FindFiles", function(args)
    require("telescope.builtin").find_files({ cwd = args.args })
end, { nargs = "?", complete = "dir", desc = "Telescope: Find files" })
map("n", "<leader>fF", ":FindFiles ", { desc = "Telescope: Find files (directory)" })

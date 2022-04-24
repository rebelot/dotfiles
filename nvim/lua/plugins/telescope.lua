local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
local trouble = require("trouble.providers.telescope")
local transform_mod = require("telescope.actions.mt").transform_mod

-- local custom_actions = {}

local function multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = #picker:get_multi_selection()
    if num_selections > 1 then
        for _, entry in ipairs(picker:get_multi_selection()) do
            vim.cmd(string.format("%s %s", open_cmd, entry.value))
        end
    else
        vim.cmd(string.format("%s %s", open_cmd, action_state.get_selected_entry().value))
    end
    vim.cmd("stopinsert")
    vim.o.winhighlight = ""
end

local custom_actions = transform_mod({
    multi_selection_open_vsplit = function(prompt_bufnr)
        multiopen(prompt_bufnr, ":vsplit")
    end,
    multi_selection_open_split = function(prompt_bufnr)
        multiopen(prompt_bufnr, ":split")
    end,
    multi_selection_open_tab = function(prompt_bufnr)
        multiopen(prompt_bufnr, ":tabe")
    end,
    multi_selection_open = function(prompt_bufnr)
        multiopen(prompt_bufnr, ":edit")
    end,
})

local function on_execute_action(action, offset_encoding)
    local getfn = function(command)
        if vim.lsp.commands[command] then
            return vim.lsp.commands[command]
        end
        for _, client in ipairs(vim.lsp.buf_get_clients(0)) do
            if client.commands[command] then
                return client.commands[command]
            end
        end
    end

    if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, offset_encoding)
    end
    if action.command then
        local command = type(action.command) == "table" and action.command or action
        local fn = getfn(command.command)
        if fn then
            fn(command, {})
        else
            vim.lsp.buf.execute_command(command)
        end
    end
end

local multi_open_mappings = {
    i = {
        ["<C-v>"] = custom_actions.multi_selection_open_vsplit,
        ["<C-s>"] = custom_actions.multi_selection_open_split,
        ["<C-t>"] = custom_actions.multi_selection_open_tab,
    },
    n = {
        ["<C-v>"] = custom_actions.multi_selection_open_vsplit,
        ["<C-s>"] = custom_actions.multi_selection_open_split,
        ["<C-t>"] = custom_actions.multi_selection_open_tab,
    },
}

require("telescope").setup({
    defaults = {
        -- dynamic_preview_title = true,
        -- borderchars = { "▔", "▕", "▁", "▏", "🭽", "🭾", "🭿", "🭼" },
        layout_strategy = "flex",
        cycle_layout_list = {"horizontal", "vertical" },
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
        file_ignore_patterns = { "node_modules", ".git" },
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
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = trouble.smart_open_with_trouble,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    require("trouble").open("loclist")
                end,
                ["<M-a>"] = actions.toggle_all,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<M-right>"] = actions_layout.cycle_layout_next,
                ["<M-left>"] = actions_layout.cycle_layout_prev,
                ["<C-o>"] = actions_layout.toggle_preview
            },
            n = {
                ["<C-z>"] = actions.toggle_selection,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = trouble.smart_open_with_trouble,
                ["<M-a>"] = actions.toggle_all,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    require("trouble").open("loclist")
                end,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
                ["<M-right>"] = actions_layout.cycle_layout_next,
                ["<M-left>"] = actions_layout.cycle_layout_prev,
                ["<C-o>"] = actions_layout.toggle_preview
            },
        },
    },
    pickers = {
        oldfiles = {
            mappings = multi_open_mappings,
        },
        find_files = {
            follow = true,
            mappings = multi_open_mappings,
        },
        buffers = {
            sort_mru = true,
            mappings = multi_open_mappings,
        },
        spell_suggest = themes.get_cursor(),
        lsp_code_actions = themes.get_cursor({
            execute_action = on_execute_action,
        }),
        lsp_range_code_actions = themes.get_cursor({
            execute_action = on_execute_action,
        }),
        lsp_references = {
            timeout = 10000,
        },
        lsp_definitions = {
            timeout = 10000,
        },
        lsp_type_definitions = {
            timeout = 10000,
        },
        lsp_implementations = {
            timeout = 10000,
        },
        lsp_workspace_symbols = {
            timeout = 10000,
        },
        lsp_dynamic_workspace_symbols = {
            timeout = 10000,
        },
    },
    extension = {
        file_browser = {
            hidden = true,
            depth = 2,
            mappings = multi_open_mappings,
        },
    },
})

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope: Find files" })
vim.keymap.set(
    "n",
    "<leader>f.",
    require("telescope").extensions.file_browser.file_browser,
    { desc = "Telescope: File browser" }
)
vim.keymap.set(
    "n",
    "<leader>fl",
    require("telescope.builtin").current_buffer_fuzzy_find,
    { desc = "Telescope: Find current buffer" }
)
vim.keymap.set("n", "<leader>fq", require("telescope.builtin").quickfix, { desc = "Telescope: Quickfix" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").oldfiles, { desc = "Telescope: Old files" })
vim.keymap.set("n", "<leader>fr", require("telescope").extensions.frecency.frecency, { desc = "Telescope: Frecency" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope: Live Grep" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").commands, { desc = "Telescope: Commands" })
vim.keymap.set("n", "<leader>ft", require("telescope.builtin").treesitter, { desc = "Telescope: Treesitter" })
vim.keymap.set("n", "<leader>fj", require("telescope.builtin").jumplist, { desc = "Telescope: Jump list" })
vim.keymap.set("n", "<leader>T", function()
    require("telescope.builtin").builtin({ include_extensions = true })
end, { desc = "Telescope: List pickers" })
vim.keymap.set("n", "<leader>z", require("telescope.builtin").spell_suggest, { desc = "Telescope: Spell suggestions" })
vim.keymap.set("n", "<leader>fm", require("telescope.builtin").marks, { desc = "Telescope: Marks" })
vim.keymap.set("n", '<leader>t"', require("telescope.builtin").registers, { desc = "Telescope: Registers" })

vim.api.nvim_create_user_command("FindFiles", function(args)
    require("telescope.builtin").find_files({ cwd = args.args })
end, { nargs = "?", complete = "dir", desc = "Telescope: Find files" })
vim.keymap.set("n", "<leader>fF", ":FindFiles ", { desc = "Telescope: Find files (directory)" })

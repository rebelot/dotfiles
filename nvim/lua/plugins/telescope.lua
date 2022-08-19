local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
local trouble = require("trouble.providers.telescope")
local transform_mod = require("telescope.actions.mt").transform_mod

local function multiopen(prompt_bufnr, method)
    local cmd_map = {
        vertical = "vsplit",
        horizontal = "split",
        tab = "tabe",
        default = "edit",
    }
    local picker = action_state.get_current_picker(prompt_bufnr)
    local multi_selection = picker:get_multi_selection()

    if #multi_selection > 0 then
        require("telescope.pickers").on_close_prompt(prompt_bufnr)
        pcall(vim.api.nvim_set_current_win, picker.original_win_id)

        for i, entry in ipairs(multi_selection) do
            -- opinionated use-case
            local cmd = i == 1 and "edit" or cmd_map[method]
            vim.cmd(string.format("%s %s", cmd, entry.value))
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

-- local function use_normal_mapping(key)
--     return function()
--         vim.cmd.stopinsert()
--         local key_code = vim.api.nvim_replace_termcodes(key, true, false, true)
--         vim.api.nvim_feedkeys(key_code, "m", false)
--     end
-- end

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
                ["<C-o>"] = actions_layout.toggle_preview,
                -- ["<CR>"] = use_normal_mapping("<CR>")
                ["<CR>"] = stopinsert(actions.select_default),
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
                ["<C-o>"] = actions_layout.toggle_preview,
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
    extensions = {
        file_browser = {
            hidden = true,
            depth = 3,
            mappings = multi_open_mappings,
        },
        ["ui-select"] = themes.get_dropdown(),
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
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Telescope: Live Grep" })
vim.keymap.set("n", "<leader>fG", function()
    require("telescope.builtin").live_grep({ grep_open_files = true })
end, { desc = "Telescope: Live Grep open_files" })
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

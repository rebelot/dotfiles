local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local themes = require("telescope.themes")
local trouble = require("trouble.providers.telescope")
local copts = { noremap = true }

local custom_actions = {}

function custom_actions._multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = #picker:get_multi_selection()
    if num_selections > 1 then
        local picker = action_state.get_current_picker(prompt_bufnr)
        for _, entry in ipairs(picker:get_multi_selection()) do
            vim.cmd(string.format("%s %s", open_cmd, entry.value))
        end
        vim.cmd("stopinsert")
    else
        actions.file_edit(prompt_bufnr)
    end
end

function custom_actions.multi_selection_open_vsplit(prompt_bufnr)
    custom_actions._multiopen(prompt_bufnr, ":vsplit")
end
function custom_actions.multi_selection_open_split(prompt_bufnr)
    custom_actions._multiopen(prompt_bufnr, ":split")
end
function custom_actions.multi_selection_open_tab(prompt_bufnr)
    custom_actions._multiopen(prompt_bufnr, ":tabe")
end
function custom_actions.multi_selection_open(prompt_bufnr)
    custom_actions._multiopen(prompt_bufnr, ":edit")
end

require("telescope").setup({
    defaults = {
        -- dynamic_preview_title = true,
        layout_strategy = "flex",
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
        history = {
            mappings = {
                i = {
                    ["<C-Down>"] = actions.cycle_history_next,
                    ["<C-Up>"] = actions.cycle_history_prev,
                },
            },
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Tab>"] = actions.move_selection_previous,
                ["<S-Tab>"] = actions.move_selection_next,
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
            },
        },
    },
    pickers = {
        oldfiles = {
            mappings = {
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
            },
        },
        find_files = {
            follow = true,
            mappings = {
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
            },
        },
        buffers = {
            sort_mru = true,
            mappings = {
                i = {
                    ["<C-r>"] = actions.delete_buffer,
                    ["<C-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<C-s>"] = custom_actions.multi_selection_open_split,
                    ["<C-t>"] = custom_actions.multi_selection_open_tab,
                },
                n = {
                    ["<C-r>"] = actions.delete_buffer,
                    ["<C-v>"] = custom_actions.multi_selection_open_vsplit,
                    ["<C-s>"] = custom_actions.multi_selection_open_split,
                    ["<C-t>"] = custom_actions.multi_selection_open_tab,
                },
            },
        },
        lsp_code_actions = themes.get_cursor(),
        lsp_range_code_actions = themes.get_cursor(),
        lsp_references = {
            timeout = 100000,
        },
        lsp_definitions = {
            timeout = 100000,
        },
        lsp_type_definitions = {
            timeout = 100000,
        },
        lsp_implementations = {
            timeout = 100000,
        },
        lsp_workspace_symbols = {
            timeout = 100000,
        },
        lsp_dynamic_workspace_symbols = {
            timeout = 100000,
        },
    },
    extension = {
        file_browser = {
            hidden = true,
            depth = 2,
            mappings = {
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
            },
        },
    }
})
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", copts)
-- vim.api.nvim_set_keymap("n", "<leader>fF", ":Telescope find_files cwd=", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>f.", "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope frecency<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>Telescope commands<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>Telescope<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Telescope spell_suggest<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", copts)
vim.api.nvim_set_keymap("n", '<leader>t"', "<cmd>Telescope registers<CR>", copts)

vim.cmd([[ command! -nargs=1 -complete=dir FindFiles Telescope find_files cwd=<args>]])
vim.api.nvim_set_keymap("n", "<leader>fF", ":FindFiles ", copts)
-- nnoremap <leader>tr :Telescope lsp_references<CR>
-- nnoremap <leader>ts :Telescope lsp_document_symbols<CR>

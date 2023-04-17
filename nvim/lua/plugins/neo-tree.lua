vim.g.neo_tree_remove_legacy_commands = 1

local function make_rename_params(old_fname, new_fname)
    return {
        files = {
            {
                oldUri = vim.uri_from_fname(old_fname),
                newUri = vim.uri_from_fname(new_fname),
            },
        },
    }
end
local function will_rename_handler(data)
    local clients = vim.lsp.get_active_clients()
    local params = make_rename_params(data.source, data.destination)
    vim.print(params)
    for _, client in ipairs(clients) do
        local willRename = vim.tbl_get(client, "server_capabilities", "workspace", "fileOperations", "willRename")
        if willRename ~= nil then
            -- local filters = willRename.filters or {}
            local resp = client.request_sync("workspace/willRenameFiles", params, 1000)
            if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
            end
        end
    end
end

local function rename_handler(data)
    local clients = vim.lsp.get_active_clients()
    local params = make_rename_params(data.source, data.destination)
    for _, client in ipairs(clients) do
        local didRename = vim.tbl_get(client, "server_capabilities", "workspace", "fileOperations", "didRename")
        if didRename ~= nil then
            -- local filters = willRename.filters or {}
            client.notify("workspace/didRenameFiles", params)
        end
    end
end

local function getTelescopeOpts(state, path)
    return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                local filename = selection.filename
                if filename == nil then
                    filename = selection[1]
                end
                -- any way to open the file without triggering auto-close event of neo-tree?
                require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
            end)
            return true
        end,
    }
end
require("neo-tree").setup({
    auto_clean_after_session_restore = false,
    popup_border_style = vim.g.FloatBorder,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
    source_selector = {
        winbar = true,
        tab_labels = {
            -- falls back to source_name if nil
            filesystem = "  Files ",
            buffers = "  Buffers ",
            git_status = "  Git ",
        },
        separator = { left = "", right = ""},
    },
    default_component_configs = {
        modified = {
            symbol = "●",
        },
        icon = {
            folder_closed = "󰉋",
            folder_open = "",
            folder_empty = "󰉖",
            default = " ",
            highlight = "NeoTreeFileIcon",
        },
        git_status = {
            symbols = {
                added = "",
                modified = "",
                conflict = "",
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "",
                untracked = "",
                deleted = "",
                ignored = "",
            },
        },
    },
    use_default_mappings = false,
    window = {
        position = "left",
        width = 40,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<Tab>"] = "toggle_node",
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
            ["<C-s>"] = "split_with_window_picker",
            ["<C-v>"] = "vsplit_with_window_picker",
            ["<C-t>"] = "open_tabnew",
            ["<C-w>"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["zM"] = "close_all_nodes",
            ["zR"] = "expand_all_nodes",
            ["R"] = "refresh",
            ["a"] = "add",
            ["A"] = "add_directory", -- also accepts the config.show_path and config.insert_as options.
            ["d"] = "delete",
            ["r"] = "rename",
            ["Y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["y"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
            ["e"] = "toggle_auto_expand_width",
            ["q"] = "close_window",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
        },
    },
    nesting_rules = {},
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            always_show = {},
            never_show = {},
            never_show_by_pattern = {},
        },
        follow_current_file = false,
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["<C-f>"] = "fuzzy_finder",
                ["<C-d>"] = "fuzzy_finder_directory",
                ["#"] = "fuzzy_sorter",
                -- ["D"] = "fuzzy_sorter_directory",
                ["f"] = "filter_on_submit",
                ["<C-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                -- custom commands
                ["i"] = "run_command",
                ["tf"] = "telescope_find",
                ["tg"] = "telescope_grep",
            },
            fuzzy_finder_mappings = {
                -- define keymaps for filter popup window in fuzzy_finder_mode
                ["<down>"] = "move_cursor_down",
                ["<C-n>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-p>"] = "move_cursor_up",
            },
        },
        commands = {
            run_command = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.api.nvim_input(": " .. path .. "<Home>")
            end,
            telescope_find = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                if vim.fn.isdirectory(path) == 0 then
                    return
                end
                require("telescope.builtin").find_files(getTelescopeOpts(state, path))
            end,
            telescope_grep = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                if vim.fn.isdirectory(path) == 0 then
                    return
                end
                require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
            end,
        },
    },
    buffers = {
        follow_current_file = true,
        group_empty_dirs = true,
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
            },
        },
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
            },
        },
    },
    event_handlers = {
        {
            event = "file_renamed",
            handler = will_rename_handler,
            id = "optional unique id, only meaningful if you want to unsubscribe later",
        },
    },
})

vim.keymap.set("n", "<leader>nt", ":Neotree source=filesystem toggle<CR>")
vim.keymap.set("n", "<leader>nf", ":Neotree source=filesystem reveal_force_cwd<cr>")
vim.keymap.set("n", "<leader>nF", ":Neotree position=float reveal_file=<cfile> reveal_force_cwd<cr>")
vim.keymap.set("n", "<leader>nb", ":Neotree source=buffers<CR>")
vim.keymap.set("n", "<leader>ng", ":Neotree source=git_status<CR>")

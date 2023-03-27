-- local tree_cb = require("nvim-tree.config").nvim_tree_callback

local api = require("nvim-tree.api")
local function on_attach(bufnr)
    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
    vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
    vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts("Rename: Omit Filename"))
    vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("Open: New Tab"))
    vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Open: Vertical Split"))
    vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
    vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
    vim.keymap.set("n", "]]", api.node.navigate.sibling.next, opts("Next Sibling"))
    vim.keymap.set("n", "[[", api.node.navigate.sibling.prev, opts("Previous Sibling"))
    vim.keymap.set("n", ".", api.node.run.cmd, opts("Run Command"))
    vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "a", api.fs.create, opts("Create"))
    vim.keymap.set("n", "bmv", api.marks.bulk.move, opts("Move Bookmarked"))
    vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
    vim.keymap.set("n", "c", api.fs.copy.node, opts("Copy"))
    vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
    vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts("Prev Git"))
    vim.keymap.set("n", "]c", api.node.navigate.git.next, opts("Next Git"))
    vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
    vim.keymap.set("n", "D", api.fs.trash, opts("Trash"))
    vim.keymap.set("n", "zR", api.tree.expand_all, opts("Expand All"))
    vim.keymap.set("n", "e", api.fs.rename_basename, opts("Rename: Basename"))
    vim.keymap.set("n", "]d", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
    vim.keymap.set("n", "[d", api.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
    vim.keymap.set("n", "F", api.live_filter.clear, opts("Clean Filter"))
    vim.keymap.set("n", "f", api.live_filter.start, opts("Filter"))
    vim.keymap.set("n", "g?", api.tree.toggle_help, opts("Help"))
    vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts("Copy Absolute Path"))
    vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
    vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
    vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
    vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
    vim.keymap.set("n", "m", api.marks.toggle, opts("Toggle Bookmark"))
    vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "O", api.node.open.no_window_picker, opts("Open: No Window Picker"))
    vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
    vim.keymap.set("n", "P", api.node.navigate.parent, opts("Parent Directory"))
    vim.keymap.set("n", "q", api.tree.close, opts("Close"))
    vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
    vim.keymap.set("n", "R", api.tree.reload, opts("Refresh"))
    vim.keymap.set("n", "s", api.node.run.system, opts("Run System"))
    vim.keymap.set("n", "S", api.tree.search_node, opts("Search"))
    vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts("Toggle Hidden"))
    vim.keymap.set("n", "zM", api.tree.collapse_all, opts("Collapse"))
    vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
    vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
    vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts("Copy Relative Path"))
    vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
    vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts("CD"))
end

require("nvim-tree").setup({
    on_attach = on_attach,
    disable_netrw = false,
    hijack_netrw = true,
    hijack_cursor = true,
    respect_buf_cwd = false,
    sync_root_with_cwd = true,
    filters = {
        dotfiles = false,
    },
    git = { enable = true, ignore = true },
    update_focused_file = {
        enable = false,
        update_root = true,
        ignore_list = { "help" },
    },
    live_filter = {
        always_show_folders = false,
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    diagnostics = {
        enable = true,
        icons = {
            error = "",
            warning = "",
            info = "",
            hint = "",
        },
    },
    modified = {
        enable = true,
    },
    actions = {
        change_dir = {
            global = true,
        },
        open_file = {
            resize_window = true,
        },
        file_popup = {
            open_win_config = {
                border = vim.g.FloatBorders
            }
        },
    },
    view = {
        adaptive_size = false,
    },
    renderer = {
        -- highlight_opened_files = 'name',
        icons = {
            git_placement = "before",
            glyphs = {
                git = {
                    unstaged = "",
                    staged = "",
                    unmerged = "",
                    renamed = "",
                    untracked = "",
                    deleted = "",
                    ignored = "",
                },
            },
        },
    },
})

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

local function file_matches_filters(fname, filters)
    for _, filter in ipairs(filters) do
        local pattern = filter.pattern
        local glob = pattern.glob
        -- local matches = pattern.matches
        local regex = vim.fn.glob2regpat(glob)
        if vim.fn.match(fname, regex) ~= -1 then
            return true
        end
    end
end

local Event = api.events.Event
api.events.subscribe(Event.NodeRenamed, function(data)
    local clients = vim.lsp.get_active_clients()
    local params = make_rename_params(data.old_name, data.new_name)
    for _, client in ipairs(clients) do
        local didRename = vim.tbl_get(client, "server_capabilities", "workspace", "fileOperations", "didRename")
        if didRename ~= nil then
            -- local filters = willRename.filters or {}
            client.notify("workspace/didRenameFiles", params)
        end
    end
end)

api.events.subscribe(Event.WillRenameNode, function(data)
    local clients = vim.lsp.get_active_clients()
    local params = make_rename_params(data.old_name, data.new_name)
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
end)

vim.keymap.set("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", { desc = "NvimTree: toggle" })
vim.keymap.set("n", "<leader>nf", "<cmd>NvimTreeFindFile!<CR>", { desc = "NvimTree: find file" })

return {
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = { { "<leader>o", "<cmd>Oil<CR>", { desc = "Oil" } } },
        opts = { default_file_explorer = false },
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "FzfLua" },
        keys = {
            { "<leader>fz", "<cmd>FzfLua builtin<CR>", { desc = "FzfLua: builtins" } },
            { "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "FzfLua: files" } },
            { "<leader>fF", "<cmd>FzfLua global<CR>", { desc = "FzfLua: global" } },
            { "<leader>fh", "<cmd>FzfLua oldfiles<CR>", { desc = "FzfLua: Recent files" } },
            { "<leader>?", "<cmd>FzfLua keymaps<CR>", { desc = "FzfLua: keymaps" } },
            { "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "FzfLua: buffers" } },
            { "<leader><space>", "<cmd>FzfLua commands<CR>", { desc = "FzfLua: commands" } },
            { "<leader>:", "<cmd>FzfLua command_history<CR>", { desc = "FzfLua: command history" } },
            { "<leader>:", "<cmd>FzfLua command_history<CR>", { desc = "FzfLua: command history" } },
            { '<leader>"', "<cmd>FzfLua registers<CR>", { desc = "FzfLua: registers" } },
            { "<leader>fG", "<cmd>FzfLua grep<CR>", { desc = "FzfLua: grep" } },
            { "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "FzfLua: live grep" } },
            {
                "<leader>fg",
                "<cmd>FzfLua grep_visual<CR>",
                mode = "x",
                { desc = "FzfLua: grep visual" },
            },
            { "<leader>fj", "<cmd>FzfLua jumps<CR>", { desc = "FzfLua: jumps" } },
            { "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "FzfLua: marks" } },
            { "<leader>fd", "<cmd>FzfLua zoxide<CR>", { desc = "FzfLua: zoxide" } },
            { "<leader>fq", "<cmd>FzfLua quickfix<CR>", { desc = "FzfLua: quickfix" } },
            { "<leader>fr", "<cmd>FzfLua resume<CR>", { desc = "FzfLua: resume" } },
            { "<leader>fH", "<cmd>FzfLua helptags<CR>", { desc = "FzfLua: helptags" } },
        },
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "fzf-lua" } })
                require("fzf-lua").register_ui_select(function(_, items)
                    local min_h, max_h = 0.15, 0.70
                    local h = #items * min_h
                    if h > max_h then
                        h = max_h
                    end
                    return {
                        winopts = {
                            height = h,
                            width = 0.40,
                            preview = { layout = "vertical" },
                        },
                        fzf_opts = {
                            ["--layout"] = "reverse-list",
                            --     ["--info"] = "hidden",
                        },
                    }
                end)
                vim.ui.select(...)
            end
        end,
        opts = {
            "borderless-full",
            fzf_opts = {
                ["--layout"] = "reverse-list",
            },
            keymap = {
                fzf = {
                    ["ctrl-z"] = false,
                    ["ctrl-q"] = "select-all+accept",
                },
            },
            oldfiles = {
                include_current_session = true,
            },
        },
        lazy = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            trouble = true,
            -- _inline2 = true,
            preview_config = {},
            on_attach = function(bufnr)
                vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk_inline<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>hb", "<cmd>Gitsigns blame_line<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>hu", "<cmd>Gitsigns undo_stage_hunk<CR>", { buffer = bufnr })
                vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { buffer = bufnr })
                vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { buffer = bufnr })
                vim.keymap.set("n", "<leader>xh", "<cmd>Gitsigns setqflist<CR>", { buffer = bufnr }) -- use trouble
            end,
        },
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },

    { "tpope/vim-fugitive", cmd = "G" },
    -- { "TimUntersberger/neogit", enabled = false },

    {
        "simnalamburt/vim-mundo",
        cmd = "MundoToggle",
        keys = { { "<leader>mu", "<cmd>MundoToggle<CR>", { desc = "Mundo: toggle" } } },
    },

    {
        "rebelot/terminal.nvim",
        dev = true,
        cmd = { "TermOpen", "TermToggle", "TermRun", "Lazygit", "IPython", "Htop" },
        keys = "<leader>t",
        event = "TermOpen",
        config = function()
            require("plugins.terminal_nvim")
        end,
    },

    { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },
    { "lambdalisue/suda.vim", cmd = { "SudaRead", "SudaWrite" } },

    {
        "chrisbra/unicode.vim",
        cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    },

    {
        "NvChad/nvim-colorizer.lua",
        -- event = { "BufReadPre", "BufNewFile" },
        cmd = { "ColorizerToggle" },
        config = true,
    },

    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && npm install && git restore .",
        cmd = "MarkdownPreview",
        ft = { "markdown", "pandoc" },
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
            -- vim.g.mkdp_browser = 'safari'
        end,
    },
    -------------------
    -- Editing Tools --
    -------------------

    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },

    {
        "junegunn/vim-easy-align",
        config = function()
            vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
        end,
        cmd = "EasyAlign",
        keys = { { mode = "x", "ga" } },
    },

    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle" },
    },

    -- {
    --     "numToStr/Comment.nvim",
    --     event = "BufReadPost",
    --     keys = { { mode = "n", "gc" }, { mode = "n", "gb" }, { mode = "x", "gc" }, { mode = "x", "gb" } },
    --     config = true,
    -- },

    {
        "kylechui/nvim-surround",
        keys = {
            { mode = "i", "<C-g>s" },
            { mode = "i", "<C-g>S" },
            { mode = "n", "ys" },
            { mode = "n", "yS" },
            { mode = "n", "cs" },
            { mode = "n", "cS" },
            { mode = "n", "ds" },
            { mode = "x", "S" },
            { mode = "x", "gS" },
        },
        config = true,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            fast_wrap = {
                chars = { "{", "[", "(", '"', "'", "`" },
                map = "<M-l>",
                keys = "asdfghjklqwertyuiop",
                pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                check_comma = true,
                end_key = "L",
                highlight = "PmenuSel",
                hightlight_grey = "NonText",
            },
            check_ts = true,
            enable_check_bracket_line = true,
        },
    },

    "wellle/targets.vim",

    {
        "michaeljsmith/vim-indent-object",
        keys = { { mode = "x", "ai" }, { mode = "x", "ii" }, { mode = "o", "ai" }, { mode = "o", "ii" } },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        enabled = false,
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "<C-S>",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },

    "tpope/vim-repeat",
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "lewis6991/async.nvim",
        },
        lazy = false,
        config = function()
            require("refactoring").setup({})
            vim.keymap.set({ "n", "x" }, "<leader>rs", function()
                require("refactoring").select_refactor()
            end, { desc = "Select refactor" })
        end,
    },
}

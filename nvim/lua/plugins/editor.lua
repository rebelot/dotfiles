return {
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = { { "<leader>o", "<cmd>Oil<CR>", { desc = "Oil" } } },
        opts = { default_file_explorer = false }
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = { "<leader>f", "<leader><space>", "<leader>k", "<leader>T" },
        cmd = "Telescope",
        enabled = true,
        dependencies = {
            {
                "nvim-telescope/telescope-frecency.nvim",
                config = function()
                    vim.keymap.set(
                        "n",
                        "<leader>fr",
                        function() require("telescope").extensions.frecency.frecency() end,
                        { desc = "Telescope: Frecency" }
                    )
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                config = function()
                    vim.keymap.set(
                        "n",
                        "<leader>f.",
                        require("telescope").extensions.file_browser.file_browser,
                        { desc = "Telescope: File browser" }
                    )
                end,
            },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            "nvim-telescope/telescope-dap.nvim",
            {
                "nvim-telescope/telescope-ui-select.nvim",
                init = function()
                    vim.ui.select = function(...)
                        require("lazy").load({ plugins = { "telescope.nvim" } })
                        vim.ui.select(...)
                    end
                end,
            },
        },
        config = function()
            require("plugins.telescope")

            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("dap")
            -- require("telescope").load_extension("notify")
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("frecency")
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            trouble = true,
            -- _inline2 = true,
            preview_config = {
            },
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

    { "tpope/vim-fugitive",   cmd = "G" },
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

    { "moll/vim-bbye",        cmd = { "Bdelete", "Bwipeout" } },
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
            { mode = "n", "ys" },
            { mode = "n", "cs" },
            { mode = "n", "ds" },
            { mode = "i", "<C-g>" },
            { mode = "x", "S" },
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
        }
    },

    "wellle/targets.vim",

    {
        "michaeljsmith/vim-indent-object",
        keys = { { mode = "x", "ai" }, { mode = "x", "ii" }, { mode = "o", "ai" }, { mode = "o", "ii" } },
    },

    -- {"folke/flash.nvim"}
    {
        "phaazon/hop.nvim",
        keys = { { mode = "n", "S" }, { mode = { "n", "x" }, "s" }, { mode = "o", "x" } },
        opts = {
            teasing = false,
            multi_window = true,
            char2_fallback_key = "<CR>",
        },
        config = function(_, opts)
            require("hop").setup(opts)
            vim.keymap.set({ "n", "x" }, "s", require("hop").hint_char2, { desc = "Hop: Hint char2" })
            vim.keymap.set({ "o" }, "x", require("hop").hint_char2, { desc = "Hop: Hint char2" })
            vim.keymap.set("n", "S", require("hop").hint_lines_skip_whitespace, { desc = "Hop: Hint line start" })
        end,
    },

    -- use 'ggandor/leap.nvim'

    "tpope/vim-repeat",
}

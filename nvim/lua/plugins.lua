local disabled_built_ins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

-- Bootstrap
------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    ----------------
    --  Required  --
    ----------------
    "nvim-lua/plenary.nvim",

    -- "lewis6991/impatient.nvim",

    { "dstein64/vim-startuptime", cmd = "StartupTime" },

    {
        "tami5/sqlite.lua",
        config = function()
            vim.g.sqlite_clib_path = "/opt/local/lib/libsqlite3.dylib"
        end,
    },

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------
    {
        "williamboman/mason.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        priority = 999,
        lazy = false,
        config = function()
            require("mason-lspconfig").setup()
        end,
    },

    {
        "neovim/nvim-lspconfig",
        priority = 998,
        lazy = false,
        config = function()
            require("lsp.server_setup")
        end,
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("lsp.null-ls")
        end,
    },

    {
        "j-hui/fidget.nvim",
        event = { "BufReadPost" },
        config = function()
            require("fidget").setup()
        end,
    },

    {
        "onsails/lspkind-nvim",
        lazy = true,
        config = function()
            require("lspkind").init({
                mode = "symbol_text",
                preset = "codicons",
                symbol_map = {
                    Copilot = "",
                },
                -- preset = "default",
            })
        end,
    },

    {
        "SmiteshP/nvim-navic",
        event = "BufReadPost",
        config = function()
            require("nvim-navic").setup({
                -- icons = require("lspkind").symbol_map,
                separator = "",
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not vim.tbl_contains({ "copilot", "null-ls", "ltex" }, client.name) then
                        require("nvim-navic").attach(client, bufnr)
                    end
                end,
            })
        end,
    },

    {
        "stevearc/aerial.nvim",
        event = "BufReadPost",
        cmd = { "AerialToggle", "AerialInfo" },
        keys = "<leader>at",
        config = function()
            require("aerial").setup({
                backends = {
                    ["_"] = { "lsp", "treesitter", "markdown", "man" },
                    markdown = { "treesitter" },
                },
                filter_kind = {
                    ["_"] = {
                        "Class",
                        "Constructor",
                        "Enum",
                        "EnumMember",
                        "Event",
                        "Field",
                        "Function",
                        "Interface",
                        "Key",
                        "Method",
                        "Module",
                        "Namespace",
                        "Operator",
                        -- "Package", -- this catches for/if ??
                        "Property",
                        "Struct",
                        "Variable",
                    },
                    -- markdown = { "String" },
                },
            })
            vim.keymap.set("n", "<leader>at", ":AerialToggle<CR>")
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            --{"hrsh7th/cmp-nvim-lua", })
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp", -- required by lsp/init.lua
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            --{ "dmitmel/cmp-cmdline-history", },
            "kdheepak/cmp-latex-symbols",
            "andersevenrud/cmp-tmux",
            {
                "quangnguyen30192/cmp-nvim-ultisnips",
                dependencies = {
                    {
                        "SirVer/ultisnips",
                        event = "InsertEnter",
                        dependencies = "honza/vim-snippets",
                        config = function()
                            vim.opt.rtp:append({ vim.fn.stdpath("data") .. "/site/pack/packer/start/vim-snippets" })
                            vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
                            vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
                            vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
                            vim.g.UltiSnipsListSnippets = "<Plug>(utlisnips_list_snippets)"
                            vim.g.UltiSnipsRemoveSelectModeMappings = 0
                        end,
                    },
                },
            },
            {
                "zbirenbaum/copilot-cmp",
                config = function()
                    require("copilot_cmp").setup()
                end,
            },
        },
        config = function()
            require("plugins.cmp")
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({
                    ft_disable = { "julia", "dap-repl" },
                    suggestion = {
                        keymap = {
                            accept = "<M-CR>",
                            next = "<M-n>",
                            prev = "<M-p>",
                            dismiss = "<C-]>",
                        },
                    },
                })
            end, 50)
        end,
    },

    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        keys = "<leader>x",
        config = function()
            require("plugins.trouble")
        end,
    },

    {
        "danymat/neogen",
        cmd = "Neogen",
        config = function()
            require("neogen").setup({})
        end,
    },

    -- use 'saadparwaiz1/cmp_luasnip'
    -- use 'L3MON4D3/LuaSnip'
    -- use 'hrsh7th/vim-vsnip'
    -- use "rafamadriz/friendly-snippets"
    -- use 'lervag/vimtex'

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    --{ "chrisbra/vim-zsh" })

    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        setup = function()
            vim.g.matchup_override_vimtex = 1
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
            }
        end,
    },

    { "chrisbra/csv.vim", ft = "csv" },

    --{
    --     "tmhedberg/SimpylFold",
    --     ft = "python",
    -- })

    --{ "Konfekt/FastFold" })

    { "jaredsampson/vim-pymol", ft = "pml" },

    --{ "vim-pandoc/vim-pandoc" })
    --{ "vim-pandoc/vim-pandoc-syntax" })

    { dir = "/opt/local/lib/plumed/vim", ft = "plumed" },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPost",
        cmd = { "TSInstall", "TSUpdate" },
        dependecies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Folded" })
                end,
            },
        },
        config = function()
            require("treesitter-config")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPost",
        config = function()
            require("plugins.indent-blankline")
        end,
    },

    -------------------------
    -- File, Fuzzy Finders --
    -------------------------

    {
        "kyazdani42/nvim-tree.lua",
        config = function()
            require("plugins.nvim-tree")
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        keys = { "<leader>f" },
        cmd = "Telescope",
        config = function()
            require("plugins.telescope")

            -- load extensions provided by plugins that are loaded _before_ telescope.
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("dap")
            require("telescope").load_extension("notify")
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("frecency")
            require("telescope").load_extension("ui-select")
        end,
    },

    {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = true,
        config = function()
            vim.keymap.set(
                "n",
                "<leader>f.",
                require("telescope").extensions.file_browser.file_browser,
                { desc = "Telescope: File browser" }
            )
        end,
    },

    {
        "nvim-telescope/telescope-dap.nvim",
        lazy = true,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        lazy = true,
        build = "make",
    },

    {
        "nvim-telescope/telescope-frecency.nvim",
        lazy = true,
        config = function()
            vim.keymap.set(
                "n",
                "<leader>fr",
                require("telescope").extensions.frecency.frecency,
                { desc = "Telescope: Frecency" }
            )
        end,
    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = true,
    },

    --{ "ibhagwan/fzf-lua", requires = { "junegunn/fzf", run = "./install --bin" } })

    -------------------------------------------
    -- Colors, Icons, StatusLine, BufferLine --
    -------------------------------------------

    {
        dir = "/Users/laurenzi/usr/src/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.o.background = nil
            local colors = require("kanagawa.colors").setup({ theme = "default" })
            require("kanagawa").setup({
                dimInactive = false,
                globalStatus = true,
                overrides = {
                    -- Pmenu = { fg = colors.fg_dark, bg = colors.bg_light0 },
                    -- PmenuSel = { fg = "NONE", bg = colors.bg_light1 },
                    -- PmenuSbar = { bg = colors.bg_dim },
                    -- PmenuThumb = { bg = colors.bg_light1 },

                    TelescopeNormal = { bg = colors.bg_dim },
                    TelescopeBorder = { fg = colors.bg_dim, bg = colors.bg_dim },
                    TelescopeTitle = { fg = colors.bg_light3, bold = true },

                    TelescopePromptNormal = { bg = colors.bg_light0 },
                    TelescopePromptBorder = { fg = colors.bg_light0, bg = colors.bg_light0 },

                    TelescopeResultsNormal = { bg = "#1a1a22" },
                    TelescopeResultsBorder = { fg = "#1a1a22", bg = "#1a1a22" },

                    TelescopePreviewNormal = { bg = colors.bg_dim },
                    TelescopePreviewBorder = { bg = colors.bg_dim, fg = colors.bg_dim },
                },
                theme = theme,
            })
            vim.cmd("colorscheme kanagawa")
        end,
    },

    { dir = "/Users/laurenzi/usr/src/lucy.nvim" },

    {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
        config = function()
            require("nvim-web-devicons").setup()
        end,
    },

    {
        dir = "/Users/laurenzi/usr/src/heirline.nvim",
        event = { "VimEnter" },
        config = function()
            require("plugins.heirline")
        end,
    },

    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        config = function()
            require("ccc").setup({ bar_len = 60 })
        end,
    },

    --------------------------
    -- Editor Utilities, UI --
    --------------------------

    {
        "mfussenegger/nvim-dap",
        lazy = true,
        config = function()
            require("dap-config")
        end,
    },

    {
        "jbyuki/one-small-step-for-vimkind",
        config = function()
            local dap = require("dap")
            dap.configurations.lua = {
                {
                    type = "nlua",
                    request = "attach",
                    name = "Attach to running Neovim instance",
                    host = function()
                        local value = vim.fn.input("Host [127.0.0.1]: ")
                        if value ~= "" then
                            return value
                        end
                        return "127.0.0.1"
                    end,
                    port = function()
                        local val = tonumber(vim.fn.input("Port: "))
                        assert(val, "Please provide a port number")
                        return val
                    end,
                },
            }

            dap.adapters.nlua = function(callback, config)
                callback({ type = "server", host = config.host, port = config.port })
            end
        end,
    },

    {
        "rcarriga/neotest",
        cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
        dependencies = {
            "rcarriga/neotest-python",
            "rcarriga/neotest-vim-test",
            "rcarriga/neotest-plenary",
            "rouge8/neotest-rust",
            "vim-test/vim-test",
        },
        config = function()
            require("plugins.neotest")
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            require("dap-python").setup() --"~/venvs/debugpy/bin/python")
            require("dap-python").test_runner = "pytest"
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        lazy = true,
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = false, -- prefix virtual text with comment string
                -- experimental features:
                virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
            })
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        config = function()
            require("dapui").setup({
                controls = {
                    enabled = true,
                    element = "repl",
                    icons = {
                        pause = "",
                        play = "",
                        step_into = "",
                        step_over = "",
                        step_out = "",
                        step_back = "",
                        run_last = "",
                        terminate = "",
                    },
                },
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        config = function()
            require("plugins.gitsigns")
        end,
    },

    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    },

    { "tpope/vim-fugitive", cmd = "G" },

    {
        "simnalamburt/vim-mundo",
        cmd = "MundoToggle",
        keys = "<leader>mu",
        config = function()
            vim.keymap.set("n", "<leader>mu", "<cmd>MundoToggle<CR>", { desc = "Mundo: toggle" })
        end,
    },

    {
        dir = "/Users/laurenzi/usr/src/terminal.nvim",
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
        -- Go Glepnir!
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("plugins.dashboard")
        end,
    },

    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    },

    {
        "rcarriga/nvim-notify",
        event = "UIEnter",
        config = function()
            local notify = require("notify")
            notify.setup({
                icons = {
                    DEBUG = "",
                    ERROR = "",
                    INFO = "",
                    HINT = "",
                    TRACE = "✎",
                    WARN = "",
                },
                -- render = "simple",
            })
            vim.notify = notify

            local vim_notify = vim.notify
            vim.notify = function(msg, ...)
                if msg:match("warning: multiple different client offset_encodings") then
                    return
                end

                vim_notify(msg, ...)
            end

            vim.keymap.set("n", "<esc>", function()
                notify.dismiss()
                vim.cmd.noh()
            end)
            vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
                vim.notify(method.message, params.type)
            end
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

    {
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        keys = { { mode = "n", "gc" }, { mode = "n", "gb" }, { mode = "x", "gc" }, { mode = "x", "gb" } },
        config = function()
            require("Comment").setup()
        end,
    },

    {
        "kylechui/nvim-surround",
        keys = {
            { mode = "n", "ys" },
            { mode = "n", "cs" },
            { mode = "n", "ds" },
            { mode = "i", "<C-g>" },
            { mode = "x", "S" },
        },
        config = function()
            require("nvim-surround").setup()
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("plugins.autopairs")
        end,
    },

    "wellle/targets.vim",

    {
        "michaeljsmith/vim-indent-object",
        keys = { { mode = "x", "ai" }, { mode = "x", "ii" }, { mode = "o", "ai" }, { mode = "o", "ii" } },
    },

    {
        "phaazon/hop.nvim",
        keys = { { mode = "n", "S" }, { mode = "n", "s" }, { mode = "x", "s" }, { mode = "o", "x" } },
        config = function()
            require("plugins.hop")
        end,
    },

    -- use 'ggandor/leap.nvim'

    "tpope/vim-repeat",

    ----------
    -- Tmux --
    ----------
    {
        "benmills/vimux",
        -- keys = '<leader>v',
        -- cmd = {'VimuxPromptCommand', 'VimuxOpenRunner'},
        config = function()
            vim.cmd([[
            function! VimuxSlime()
                call VimuxRunCommand(@v, 0)
            endfunction
            ]])
            vim.keymap.set("x", "<leader>vs", '"vy :call VimuxSlime()<CR>', { desc = "Vimux: send selection" })
            vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<CR>", { desc = "Vimux: prompt command" })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "python",
                command = [[xnoremap <buffer> <leader>vs "+y :call VimuxRunCommand('%paste')<CR>]],
            })
        end,
    },
}

require("lazy").setup(plugins)

-- vim.opt.rtp:append({
--     "/Users/laurenzi/usr/src/kanagawa.nvim",
--     "/Users/laurenzi/usr/src/heirline.nvim",
--     "/Users/laurenzi/usr/src/terminal.nvim",
-- })

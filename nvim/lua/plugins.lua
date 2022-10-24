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
-- local execute = vim.api.nvim_command
-- local fn = vim.fn

-- local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- if fn.empty(fn.glob(install_path)) > 0 then
--     fn.system({
--         "git",
--         "clone",
--         "https://github.com/wbthomason/packer.nvim",
--         install_path,
--     })
--     execute("packadd packer.nvim")
-- end

-- autocompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("packer").init({
    max_jobs = 50,
    display = {
        -- unusable until wbthomason/packer.nvim#459 is fixed
        -- open_fn = function()
        --     return require("packer.util").float({ border = require("lsp").borders })
        -- end,
        prompt_border = require("lsp").borders,
    },
})

return require("packer").startup(function(use)
    ----------------
    --  Required  --
    ----------------

    use("wbthomason/packer.nvim")

    use("nvim-lua/plenary.nvim")

    use("lewis6991/impatient.nvim")

    use({ "dstein64/vim-startuptime", cmd = "StartupTime" })

    use({
        "tami5/sqlite.lua",
        config = function()
            vim.g.sqlite_clib_path = "/opt/local/lib/libsqlite3.dylib"
        end,
    })

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------
    use({
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    })

    use({
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        after = "mason-lspconfig.nvim",
        config = function()
            require("lsp.server_setup")
        end,
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-lspconfig",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("lsp.null-ls")
        end,
    })

    use({
        "j-hui/fidget.nvim",
        event = { "BufRead" },
        config = function()
            require("fidget").setup()
        end,
    })

    use({
        "onsails/lspkind-nvim",
        module = "lspkind",
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
    })

    use({
        "SmiteshP/nvim-navic",
        after = { "lspkind-nvim" },
        event = "BufRead",
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
    })

    use({
        "stevearc/aerial.nvim",
        event = "BufRead",
        cmd = { "AerialToggle", "AerialInfo" },
        keys = { { "n", "<leader>at" } },
        config = function()
            require("aerial").setup({
                backends = { "lsp", "treesitter", "markdown" },
                filter_kind = {
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
            })
            vim.keymap.set("n", "<leader>at", ":AerialToggle<CR>")
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("aerial").on_attach(client, bufnr)
                end,
            })
        end,
    })

    use({
        "SirVer/ultisnips",
        requires = "honza/vim-snippets",
        config = function()
            vim.opt.rtp:append({ vim.fn.stdpath("data") .. "/site/pack/packer/start/vim-snippets" })
            vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
            vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
            vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
            vim.g.UltiSnipsListSnippets = "<Plug>(utlisnips_list_snippets)"
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end,
    })

    use({
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        config = function()
            require("plugins.cmp")
        end,
    })

    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    -- use({"hrsh7th/cmp-nvim-lua", after = "nvim-cmp"})
    use({ "hrsh7th/cmp-cmdline", after = "nvim-cmp" })
    use("hrsh7th/cmp-nvim-lsp") -- required by lsp/init.lua
    use({ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" })
    -- use({ "dmitmel/cmp-cmdline-history", after = "nvim-cmp" })
    use({ "kdheepak/cmp-latex-symbols", after = "nvim-cmp" })
    use({ "andersevenrud/cmp-tmux", after = "nvim-cmp" })
    use({ "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp" })

    use({
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
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
            end, 1000)
        end,
    })

    use({
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua", "nvim-cmp" },
        config = function()
            require("copilot_cmp").setup()
        end,
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("plugins.trouble")
        end,
    })

    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({})
        end,
        cmd = "Neogen",
    })

    -- use 'saadparwaiz1/cmp_luasnip'
    -- use 'L3MON4D3/LuaSnip'
    -- use 'hrsh7th/vim-vsnip'
    -- use "rafamadriz/friendly-snippets"
    -- use 'lervag/vimtex'

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    -- use({ "chrisbra/vim-zsh" })

    use({
        "andymass/vim-matchup",
        event = "BufRead",
        config = function()
            vim.g.matchup_override_vimtex = 1
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
            }
        end,
    })

    use({
        "chrisbra/csv.vim",
        ft = "csv",
    })

    -- use({
    --     "tmhedberg/SimpylFold",
    --     ft = "python",
    -- })

    -- use({ "Konfekt/FastFold" })

    use({ "jaredsampson/vim-pymol", ft = "pml" })

    -- use({ "vim-pandoc/vim-pandoc" })
    -- use({ "vim-pandoc/vim-pandoc-syntax" })

    -- use '/opt/plumed-2.4.3/lib/plumed/vim'

    use({
        -- WARN: Issues with telescope. Lazy-loading telescope solves the issue.
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufRead",
        cmd = { "TSInstall", "TSUpdate" },
        config = function()
            require("treesitter-config")
        end,
    })

    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
    })

    use({
        "RRethy/nvim-treesitter-textsubjects",
        after = "nvim-treesitter",
    })

    use({
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Folded" })
        end,
    })

    use({
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent-blankline")
        end,
        event = "BufRead",
        after = "nvim-treesitter",
    })

    -------------------------
    -- File, Fuzzy Finders --
    -------------------------

    use({
        "kyazdani42/nvim-tree.lua",
        config = function()
            require("plugins.nvim-tree")
        end,
    })

    use({
        -- WARN: Issues with treesitter. Lazy-loading telescope solves the issue.
        "nvim-telescope/telescope.nvim",
        keys = { { "n", "<leader>f" }, { "n", "<leader>t" } },
        cmd = "Telescope",
        module = "telescope",
        config = function()
            require("plugins.telescope")

            -- load extensions provided by plugins that are loaded _before_ telescope.
            require("telescope").load_extension("notify")
        end,
    })

    use({
        "nvim-telescope/telescope-file-browser.nvim",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("file_browser")
            vim.keymap.set(
                "n",
                "<leader>f.",
                require("telescope").extensions.file_browser.file_browser,
                { desc = "Telescope: File browser" }
            )
        end,
    })

    use({
        "nvim-telescope/telescope-dap.nvim",
        after = { "telescope.nvim", "nvim-dap" },
        config = function()
            require("telescope").load_extension("dap")
        end,
    })

    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        after = "telescope.nvim",
        run = "make",
        config = function()
            require("telescope").load_extension("fzf")
        end,
    })

    use({
        "nvim-telescope/telescope-frecency.nvim",
        after = { "telescope.nvim" }, --, "sqlite.lua" },
        config = function()
            require("telescope").load_extension("frecency")
            vim.keymap.set(
                "n",
                "<leader>fr",
                require("telescope").extensions.frecency.frecency,
                { desc = "Telescope: Frecency" }
            )
        end,
    })

    use({
        "nvim-telescope/telescope-ui-select.nvim",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("ui-select")
        end,
    })

    -------------------------------------------
    -- Colors, Icons, StatusLine, BufferLine --
    -------------------------------------------

    use("/Users/laurenzi/usr/src/kanagawa.nvim")

    use("/Users/laurenzi/usr/src/lucy.nvim")

    use({
        "kyazdani42/nvim-web-devicons",
        module = "nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end,
    })

    use({
        "/Users/laurenzi/usr/src/heirline.nvim",
        event = { "UIEnter" },
        config = function()
            require("plugins.heirline")
        end,
    })

    use({
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        config = function()
            require("ccc").setup({ bar_len = 60 })
        end,
    })

    --------------------------
    -- Editor Utilities, UI --
    --------------------------

    use({
        "mfussenegger/nvim-dap",
        config = function()
            require("dap-config")
        end,
    })

    use({
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
    })

    use({
        "rcarriga/neotest",
        cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- "antoinemadec/FixCursorHold.nvim",
            "rcarriga/neotest-python",
            "rcarriga/neotest-vim-test",
            "rcarriga/neotest-plenary",
            "vim-test/vim-test",
        },
        config = function()
            require("plugins.neotest")
        end,
    })

    use({
        "mfussenegger/nvim-dap-python",
        after = "nvim-dap",
        ft = "python",
        config = function()
            require("dap-python").setup() --"~/venvs/debugpy/bin/python")
            require("dap-python").test_runner = "pytest"
        end,
    })

    use({
        "theHamsta/nvim-dap-virtual-text",
        after = "nvim-dap",
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
    })

    use({
        "rcarriga/nvim-dap-ui",
        after = "nvim-dap",
        module = "dapui",
        config = function()
            require("dapui").setup()
        end,
    })

    use({
        "lewis6991/gitsigns.nvim",
        after = "trouble.nvim",
        event = "BufRead",
        config = function()
            require("plugins.gitsigns")
        end,
    })

    use({
        "sindrets/diffview.nvim",
        requires = "nvim-lua/plenary.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    })

    use({ "tpope/vim-fugitive", cmd = "G" })

    use({
        "simnalamburt/vim-mundo",
        cmd = { "MundoToggle" },
        keys = { { "n", "<leader>mu" } },
        config = function()
            vim.keymap.set("n", "<leader>mu", "<cmd>MundoToggle<CR>", { desc = "Mundo: toggle" })
        end,
    })

    use({
        "/Users/laurenzi/usr/src/terminal.nvim",
        -- cmd = { "TermOpen", "TermRun" },
        -- keys = "<leader>t",
        -- event = "TermOpen",
        config = function()
            require("plugins.terminal_nvim")
        end,
    })

    use({ "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } })

    use({ "lambdalisue/suda.vim", cmd = { "SudaRead, SudaWrite" } })

    use({
        "chrisbra/unicode.vim",
        cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    })

    use({
        -- Go Glepnir!
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("plugins.dashboard")
        end,
    })

    use({
        "norcalli/nvim-colorizer.lua",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("colorizer").setup()
        end,
    })

    use({
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
            vim.keymap.set("n", "<esc>", function()
                notify.dismiss()
                vim.cmd.noh()
            end)
            vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
                vim.notify(method.message, params.type)
            end
        end,
    })

    -------------------
    -- Editing Tools --
    -------------------

    use({
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    })

    use({
        "junegunn/vim-easy-align",
        config = function()
            vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
        end,
        cmd = "EasyAlign",
        keys = { { "x", "ga" } },
    })

    use({
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle" },
    })

    use({
        "numToStr/Comment.nvim",
        -- event = "BufRead",
        keys = { { "n", "gc" }, { "n", "gb" }, { "x", "gc" }, { "x", "gb" } },
        config = function()
            require("Comment").setup()
        end,
    })

    use({
        "kylechui/nvim-surround",
        keys = { { "n", "ys" }, { "n", "cs" }, { "n", "ds" }, { "i", "<C-g>" }, { "x", "S" } },
        config = function()
            require("nvim-surround").setup()
        end,
    })

    use({
        "windwp/nvim-autopairs",
        after = { "nvim-cmp" },
        config = function()
            require("plugins.autopairs")
        end,
    })

    use("wellle/targets.vim")

    use({
        "michaeljsmith/vim-indent-object",
        keys = { { "x", "ai" }, { "x", "ii" }, { "o", "ai" }, { "o", "ii" } },
    })

    use({
        "phaazon/hop.nvim",
        as = "hop",
        keys = { { "n", "S" }, { "n", "s" }, { "x", "s" }, { "o", "x" } },
        config = function()
            require("plugins.hop")
        end,
    })

    use("tpope/vim-repeat")

    ----------
    -- Tmux --
    ----------
    use({
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
    })
end)

-- vim.opt.rtp:append({
--     "/Users/laurenzi/usr/src/kanagawa.nvim",
--     "/Users/laurenzi/usr/src/heirline.nvim",
--     "/Users/laurenzi/usr/src/terminal.nvim",
-- })

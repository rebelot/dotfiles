local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- bootstap
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    execute("packadd packer.nvim")
end

-- autocompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("packer").init({
    max_jobs = 50,
})

return require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim" })

    use({ "nvim-lua/plenary.nvim" })

    use({ "nvim-lua/popup.nvim" })

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------

    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("lsp.lsp-config")
        end,
    })
    -- use "ray-x/lsp_signature.nvim"

    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-lspconfig",
        disable = false,
        config = function()
            require("lsp.null-ls")
        end,
    })

    -- use({ "simrat39/symbols-outline.nvim" })

    -- use({ "b0o/SchemaStore.nvim" })

    use({
        "nvim-lua/lsp-status.nvim",
        config = function()
            require("lsp.lsp-status")
        end,
    })

    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })

    use({
        "onsails/lspkind-nvim",
        config = function()
            require("lspkind").init({
                mode = "symbol_text",
                preset = "codicons",
                -- preset = "default",
            })
        end,
    })

    use({
        "SmiteshP/nvim-gps",
        after = { "nvim-treesitter", "lspkind-nvim" },
        config = function()
            local getkind = function(kind)
                local kinds = vim.lsp.protocol.CompletionItemKind
                return kinds[kinds[kind]]:match("^.*%s")
            end
            require("nvim-gps").setup({
                icons = {
                    ["class-name"] = getkind("Class"),
                    ["function-name"] = getkind("Function"),
                    ["method-name"] = getkind("Method"),
                    ["container-name"] = getkind("Enum"),
                    -- ["tag-name"] = ' '
                },
            })
        end,
    })

    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.cmp")
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            {
                "uga-rosa/cmp-dictionary",
                config = function()
                    require("cmp_dictionary").setup({
                        dic = {
                            ["*"] = "/usr/share/dict/words",
                        },
                    })
                end,
            },
            "kdheepak/cmp-latex-symbols",
            "dmitmel/cmp-cmdline-history",
            "andersevenrud/cmp-tmux",
            "quangnguyen30192/cmp-nvim-ultisnips",
        },
    })

    use({
        "SirVer/ultisnips",
        requires = "honza/vim-snippets",
        config = function()
            vim.opt.rtp:append({ vim.fn.stdpath("data") .. "/site/pack/packer/start/vim-snippets" })
            vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
            vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
            vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
            vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end,
    })

    use({
        "folke/trouble.nvim",
        config = function()
            require("plugins.trouble")
        end,
    })

    use({
        "liuchengxu/vista.vim",
        cmd = "Vista",
        keys = "<leader>vv",
        config = function()
            require("plugins.vista")
        end,
    })

    -- use 'saadparwaiz1/cmp_luasnip'
    -- use 'L3MON4D3/LuaSnip'
    -- use 'hrsh7th/vim-vsnip'
    -- use "rafamadriz/friendly-snippets"
    -- use 'lervag/vimtex'

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    -- use 'plasticboy/vim-markdown'
    use({ "JuliaEditorSupport/julia-vim" })

    use({
        "chrisbra/vim-zsh",
        ft = "zsh",
    })

    use({
        "andymass/vim-matchup",
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
        cmd = "CSVInit",
    })

    use({
        "vim-python/python-syntax",
        ft = "python",
        config = function()
            vim.g.python_highlight_all = 1
            vim.g.python_highlight_file_headers_as_comments = 1
            vim.g.python_highlight_space_errors = 0
        end,
    })

    use({
        "tmhedberg/SimpylFold",
        ft = "python",
    })

    use({ "Konfekt/FastFold" })

    use({ "jaredsampson/vim-pymol" })

    -- use({ "vim-pandoc/vim-pandoc" })

    -- use({ "vim-pandoc/vim-pandoc-syntax" })
    -- use '/opt/plumed-2.4.3/lib/plumed/vim'

    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("treesitter-config")
        end,
    })

    use({
        "nvim-treesitter/playground",
        after = "nvim-treesitter",
        cmd = "TSPlaygroundToggle",
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
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent-blankline")
        end,
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
        "junegunn/fzf",
        dir = "~/.fzf",
        run = "./install --all",
    })

    use({ "junegunn/fzf.vim" })

    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require("plugins.telescope")
        end,
    })
    use({
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
            require("telescope").load_extension("file_browser")
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
        after = { "telescope.nvim", "sqlite.lua" },
        config = function()
            require("telescope").load_extension("frecency")
        end,
    })

    use({
        "tami5/sqlite.lua",
        config = function()
            vim.g.sqlite_clib_path = "/opt/local/lib/libsqlite3.dylib"
        end,
    })

    -------------------------------------------
    -- Colors, Icons, StatusLine, BufferLine --
    -------------------------------------------

    -- use 'ryanoasis/vim-devicons'
    use({ "/Users/laurenzi/usr/src/kanagawa.nvim", branch = "master" })
    -- use({ "rebelot/kanagawa.nvim", branch = "master" })

    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end,
    })
    -- use 'rktjmp/lush.nvim'
    -- use 'npxbr/gruvbox.nvim'
    -- use 'sainnhe/gruvbox-material'
    use({ "folke/tokyonight.nvim" })

    use({
        "catppuccin/nvim",
        as = "catppuccin",
    })
    -- use 'rmehri01/onenord.nvim'
    -- use 'arcticicestudio/nord-vim'
    use("shaunsingh/nord.nvim")
    -- use "projekt0n/github-nvim-theme"
    -- use 'gruvbox-community/gruvbox'
    use({
        "/Users/laurenzi/usr/src/heirline.nvim",
        event = { "VimEnter" },
        config = function()
            require("plugins.heirline")
        end,
    })
    -- use({
    --     "famiu/feline.nvim",
    --     after = { "nvim-lspconfig", "tokyonight.nvim", "gitsigns.nvim", "nvim-dap", "vim-ultest" },
    --     event = { "BufEnter" },
    --     config = function()
    --         require("plugins.feline")
    --     end,
    -- })

    use({
        "akinsho/nvim-bufferline.lua",
        event = { "VimEnter" },
        config = function()
            require("plugins.bufferline")
        end,
    })

    use({ "junegunn/goyo.vim" })

    use({ "junegunn/limelight.vim" })

    --------------------------
    -- Editor Utilities, UI --
    --------------------------

    use({
        "w0rp/ale",
        config = function()
            require("plugins.ale")
        end,
    })

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
        "rcarriga/vim-ultest",
        requires = { "vim-test/vim-test" },
        run = ":UpdateRemotePlugins",
        config = function()
            require("plugins.ultest")
        end,
    })

    use({
        "mfussenegger/nvim-dap-python",
        after = "nvim-dap",
        config = function()
            require("dap-python").setup("~/venvs/debugpy/bin/python")
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
        config = function()
            require("plugins.gitsigns")
        end,
    })

    use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

    use({ "tpope/vim-fugitive" })
    -- use 'mhinz/vim-signify'
    -- use 'ludovicchabant/vim-gutentags'
    use({
        "majutsushi/tagbar",
        cmd = { "TagbarToggle" },
        keys = "<F8>",
        config = function()
            vim.api.nvim_set_keymap("n", "<F8>", "<cmd>TagbarToggle<CR>", { noremap = true })
        end,
    })

    use({
        "simnalamburt/vim-mundo",
        cmd = { "MundoToggle" },
        keys = "<leader>mu",
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>mu", "<cmd>MundoToggle<CR>", { noremap = true })
        end,
    })

    use({
        "junegunn/vim-peekaboo",
        config = function()
            vim.g.peekaboo_compact = 0
            vim.g.peekaboo_window = "vert bo 30 new"
        end,
    })
    -- use 'kassio/neoterm'
    use("voldikss/vim-floaterm")
    -- use "numToStr/FTerm.nvim"

    use({ "moll/vim-bbye" })

    use({ "lambdalisue/suda.vim" })
    -- use {'wesQ3/vim-windowswap', config = function() g.windowswap_map_keys = 0 end }
    -- use 'fsharpasharp/nvim-historian'
    -- use 'neomake/neomake'
    -- use {'jmcantrell/vim-virtualenv', config = function() g.virtualenv_directory = '~/venvs/' end}
    use({
        "chrisbra/unicode.vim",
        cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    })

    use({
        "glepnir/dashboard-nvim",
        config = function()
            require("plugins.dashboard")
        end,
    })

    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
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
            vim.cmd("xmap ga <Plug>(EasyAlign)")
        end,
    })

    use({
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle" },
    })
    -- use 'tpope/vim-commentary'
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup({ mappings = { extended = true } })
        end,
    })

    use({ "tpope/vim-surround" })

    use({
        "ThePrimeagen/refactoring.nvim",
        after = "nvim-treesitter",
        config = function()
            require("refactoring").setup({})
        end,
    })

    -- use {'raimondi/delimitmate',
    --   config = function()
    --     vim.g.delimitMate_expand_inside_quotes = 0
    --     vim.g.delimitMate_jump_expansion = 1
    --     vim.g.delimitMate_expand_cr = 2
    --     vim.g.delimitMate_expand_space = 1
    --     vim.g.delimitMate_nesting_quotes = {'"','`'}
    --
    --     vim.cmd [[
    --       imap <C-l> <Plug>delimitMateS-Tab
    --       augroup DelimitMateFT
    --       autocmd!
    --       autocmd FileType python let b:delimitMate_nesting_quotes = ['"']
    --       autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']
    --       augroup end
    --     ]]
    --   end
    -- }
    use({
        "windwp/nvim-autopairs",
        after = { "hop", "nvim-cmp" },
        config = function()
            require("plugins.autopairs")
        end,
    })

    use({ "wellle/targets.vim" })

    use({ "michaeljsmith/vim-indent-object" })
    -- use 'justinmk/vim-sneak'
    -- use {'ggandor/lightspeed.nvim', rtp = '.',
    --   config = function()
    --   vim.cmd [[
    --     nmap <expr> f reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_f" : "f"
    --     nmap <expr> F reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_F" : "F"
    --     nmap <expr> t reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_t" : "t"
    --     nmap <expr> T reg_recording() . reg_executing() == "" ? "<Plug>Lightspeed_T" : "T"
    --   ]]
    -- end
    -- }
    use({
        "phaazon/hop.nvim",
        as = "hop",
        disable = false,
        config = function()
            require("plugins.hop")
        end,
    })

    use({ "tpope/vim-repeat" })

    use({ "chrisbra/NrrwRgn" })
    -- }}}

    ----------
    -- Tmux --
    ----------
    use({
        "benmills/vimux",
        config = function()
            vim.cmd([[
            function! VimuxSlime()
            call VimuxRunCommand(@v, 0)
            endfunction
            ]])
            vim.api.nvim_set_keymap("x", "<leader>vs", '"vy :call VimuxSlime()<CR>', { noremap = true })
            vim.api.nvim_set_keymap("n", "<leader>vp", "<cmd>VimuxPromptCommand<CR>", { noremap = true })
        end,
    })

    use({ "tmux-plugins/vim-tmux" })
    -- use 'tmux-plugins/vim-tmux-focus-events'
    -- }}}
end)

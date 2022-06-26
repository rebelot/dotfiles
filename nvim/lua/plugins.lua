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

    use({ "lewis6991/impatient.nvim" })

    use({ "dstein64/vim-startuptime" })

    use({
        "tami5/sqlite.lua",
        config = function()
            vim.g.sqlite_clib_path = "/opt/local/lib/libsqlite3.dylib"
        end,
    })

    use({
        "antoinemadec/FixCursorHold.nvim",
        config = function()
            vim.g.cursorhold_updatetime = 250
        end,
    })

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------

    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("lsp.lsp-config")
        end,
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("lsp.null-ls")
        end,
    })

    -- use({ "b0o/SchemaStore.nvim" })

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
        "SmiteshP/nvim-navic",
        after = { "lspkind-nvim" },
        config = function()
            require("nvim-navic").setup({ icons = require("lspkind").symbol_map })
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
        cmd = "AerialToggle",
        config = function()
            require("aerial").setup()
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
        "hrsh7th/nvim-cmp",
        config = function()
            require("plugins.cmp")
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            -- {
            --     "uga-rosa/cmp-dictionary",
            --     ft = { 'markdown' },
            --     config = function()
            --         require("cmp_dictionary").setup({
            --             dic = {
            --                 ["*"] = "/usr/share/dict/words",
            --             },
            --         })
            --     end,
            -- },
            "kdheepak/cmp-latex-symbols",
            "dmitmel/cmp-cmdline-history",
            -- "andersevenrud/cmp-tmux",
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
            vim.g.UltiSnipsListSnippets = "<Plug>(utlisnips_list_snippets)"
            vim.g.UltiSnipsRemoveSelectModeMappings = 0
        end,
    })

    use({
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({ ft_disable = { "julia" } })
            end, 1000)
        end,
    })

    use({
        "zbirenbaum/copilot-cmp",
        module = "copilot_cmp",
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
    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({})
        end,
        cmd = "Neogen",
    })
    -- use({
    --     "ldelossa/litee.nvim",
    --     requires = {
    --         -- "ldelossa/litee-symboltree.nvim",
    --         "ldelossa/litee-calltree.nvim" },
    --     config = function()
    --         require('litee.lib').setup({})
    --         require('litee.calltree').setup({})
    --         -- require('litee.symboltree').setup({})
    --     end
    -- })

    -- use 'saadparwaiz1/cmp_luasnip'
    -- use 'L3MON4D3/LuaSnip'
    -- use 'hrsh7th/vim-vsnip'
    -- use "rafamadriz/friendly-snippets"
    -- use 'lervag/vimtex'

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    -- use 'plasticboy/vim-markdown'
    -- use({ "JuliaEditorSupport/julia-vim" })

    -- use({ "chrisbra/vim-zsh" })

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
        "tmhedberg/SimpylFold",
        ft = "python",
    })

    -- use({ "Konfekt/FastFold" })

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
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Folded" })
        end,
    })

    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("plugins.indent-blankline")
        end,
        event = "BufEnter",
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
        "nvim-telescope/telescope.nvim",
        config = function()
            require("plugins.telescope")
        end,
    })

    use({
        "nvim-telescope/telescope-file-browser.nvim",
        after = "telescope.nvim",
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

    use({ "/Users/laurenzi/usr/src/kanagawa.nvim", branch = "master" })
    -- use({ "rebelot/kanagawa.nvim", branch = "master" })

    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end,
    })
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

    use({
        "akinsho/nvim-bufferline.lua",
        event = { "VimEnter" },
        config = function()
            require("plugins.bufferline")
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

    -- use({
    --     "rcarriga/vim-ultest",
    --     requires = { "vim-test/vim-test" },
    --     run = ":UpdateRemotePlugins",
    --     config = function()
    --         require("plugins.ultest")
    --     end,
    -- })

    use({
        "rcarriga/neotest",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
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
        event = "BufEnter",
    })

    use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

    use({ "tpope/vim-fugitive" })

    use({
        "majutsushi/tagbar",
        cmd = { "TagbarToggle" },
        keys = "<F8>",
        config = function()
            vim.keymap.set("n", "<F8>", "<cmd>TagbarToggle<CR>", { desc = "Tagbar: toggle" })
        end,
    })

    use({
        "simnalamburt/vim-mundo",
        cmd = { "MundoToggle" },
        keys = "<leader>mu",
        config = function()
            vim.keymap.set("n", "<leader>mu", "<cmd>MundoToggle<CR>", { desc = "Mundo: toggle" })
        end,
    })

    use({
        "/Users/laurenzi/usr/src/terminal.nvim",
        -- event = "TermOpen",
        -- keys = {"<leader>to", '<leader>st'},
        config = function()
            local term_map = require("terminal.mappings")
            require("terminal").setup()
            vim.keymap.set({ "n", "x" }, "<leader>ts", term_map.operator_send, { expr = true })
            vim.keymap.set("n", "<leader>to", term_map.toggle)
            vim.keymap.set("n", "<leader>tO", term_map.toggle({ open_cmd = "enew" }))
            vim.keymap.set("n", "<leader>tr", term_map.run)
            vim.keymap.set("n", "<leader>tR", term_map.run(nil, { layout = { open_cmd = "enew" } }))
            vim.keymap.set("n", "<leader>tk", term_map.kill)
            vim.keymap.set("n", "<leader>t]", term_map.cycle_next)
            vim.keymap.set("n", "<leader>t[", term_map.cycle_prev)
            local ipython = require("terminal").terminal:new({
                layout = { open_cmd = "botright vertical new" },
                cmd = { "ipython" },
                autoclose = true,
            })
            local htop = require("terminal").terminal:new({
                layout = { open_cmd = "float" },
                cmd = { "htop" },
                autoclose = true,
            })
            local lazygit = require("terminal").terminal:new({
                layout = { open_cmd = "float", height = 0.9, width = 0.9 },
                cmd = { "lazygit" },
                autoclose = true,
            })
            vim.env["GIT_EDITOR"] = "nvr -cc close -cc split --remote-wait +'set bufhidden=wipe'"

            vim.api.nvim_create_user_command("IPython", function()
                local bufnr = vim.api.nvim_get_current_buf()
                vim.keymap.set("x", "<leader>ts", function()
                    vim.api.nvim_feedkeys('"+y', "n", false)
                    ipython:send("%paste")
                end, { buffer = bufnr })
                vim.keymap.set("n", "<leader>t?", function()
                    require("terminal").send(vim.v.count, vim.fn.expand("<cexpr>") .. "?")
                end, { buffer = bufnr })
                ipython:toggle(nil, true)
            end, {})

            vim.api.nvim_create_user_command("Lazygit", function(args)
                lazygit.cwd = args.args and vim.fn.expand(args.args)
                lazygit:toggle(nil, true)
            end, { nargs = "?" })

            vim.api.nvim_create_user_command("Htop", function()
                htop:toggle(nil, true)
            end, { nargs = "?" })

        end,
    })

    use({ "moll/vim-bbye", cmd = "Bdelete" })

    use({ "lambdalisue/suda.vim", cmd = { "SudaRead, SudaWrite" } })
    -- use 'neomake/neomake'
    use({
        "chrisbra/unicode.vim",
        cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    })

    use({
        "goolord/alpha-nvim",
        config = function()
            require("plugins.dashboard")
        end,
    })

    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
        event = "BufEnter",
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
        keys = { "ga" },
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

    use({
        "tpope/vim-surround",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "tex",
                command = [[let g:surround_92 = "\\\1\\\1{\r}"]],
            })
        end,
    })

    -- use({
    --     "ThePrimeagen/refactoring.nvim",
    --     after = "nvim-treesitter",
    --     config = function()
    --         require("refactoring").setup({})
    --     end,
    -- })

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
        event = "InsertCharPre",
    })

    use({ "wellle/targets.vim" })

    use({ "michaeljsmith/vim-indent-object" })
    use({
        "phaazon/hop.nvim",
        as = "hop",
        config = function()
            require("plugins.hop")
        end,
    })

    use({ "tpope/vim-repeat" }) --, keys = "." })

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
            vim.keymap.set("x", "<leader>vs", '"vy :call VimuxSlime()<CR>', { desc = "Vimux: send selection" })
            vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<CR>", { desc = "Vimux: prompt command" })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "python",
                command = [[xnoremap <buffer> <leader>vs "+y :call VimuxRunCommand('%paste')<CR>]],
            })
        end,
    })
    -- }}}
end)

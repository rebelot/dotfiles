local disabled_rtp_plugins = {
    -- "netrw",
    -- "netrwPlugin",
    -- "netrwSettings",
    -- "netrwFileHandlers",
    -- "matchit",
    "gzip",
    "tutor",
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
}

-- Bootstrap
------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    ----------------
    --  Required  --
    ----------------
    { "nvim-lua/plenary.nvim",    lazy = true },

    { "dstein64/vim-startuptime", cmd = "StartupTime" },

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------

    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        event = { "BufRead", "BufNewFile" },
        config = function()
            require("mason").setup()
            require("lsp.init")
        end,
    },

    {
        "mrcjkb/rustaceanvim",
        lazy = false, -- This plugin is already lazy
        init = function()
            vim.g.rustaceanvim = {
                tools = {
                    float_win_config = {
                        border = vim.g.FloatBorders,
                    },
                },
                server = {
                    on_attach = require("lsp.init").default_on_attach,
                    -- capabilities = require("lsp.init").default_capabilities,
                    capabilities = vim.lsp.protocol.make_client_capabilities(),
                    default_settings = {
                        -- rust-analyzer language server configuration
                        ["rust-analyzer"] = {
                            check = {
                                command = "clippy",
                            },
                        },
                    },
                },
                -- DAP configuration
                dap = {},
            }
        end,
    },
    { "barreiroleo/ltex_extra.nvim", lazy = true },
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        enabled = false,
        -- dependencies = { "luarocks.nvim" },
        config = function()
            require("rest-nvim").setup()
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        event = { "BufRead", "BufNewFile" },
        enabled = false,
        config = function()
            require("lsp.null-ls")
        end,
    },

    {
        "j-hui/fidget.nvim",
        enabled = true,
        event = { "BufRead", "BufNewFile" },
        opts = {
            notification = {
                override_vim_notify = true,
            },
        },
    },

    {
        "SmiteshP/nvim-navic",
        enabled = true,
        event = "BufReadPost",
        config = function()
            require("nvim-navic").setup({
                -- icons = require("lspkind").symbol_map,
                separator = "",
                icons = require("lsp.init").symbol_icons,
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end
                    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
                        require("nvim-navic").attach(client, bufnr)
                    end
                end,
            })
        end,
    },

    {
        'saghen/blink.cmp',
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = { 'rafamadriz/friendly-snippets', "fang2hou/blink-copilot" },
        build = 'cargo build --release',
        config = function()
            require("plugins.blink-cmp")
        end
    },

    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        opts = {
            filetypes = { julia = false, ["dap-repl"] = false },
            panel = {
                enabled = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "R",
                    open = "<M-CR>"
                },
                layout = {
                    position = "right", -- | top | left | right | horizontal | vertical
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = false,
                auto_trigger = false,
                keymap = {
                    accept = "<M-CR>",
                    next = "<M-n>",
                    prev = "<M-p>",
                    dismiss = "<C-]>",

                },
            },
        },
    },

    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        keys = "<leader>x",
        config = function()
            require("plugins.trouble")
        end,
    },

    {
        "danymat/neogen",
        cmd = "Neogen",
        config = true,
    },

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    --{ "chrisbra/vim-zsh" })

    {
        "andymass/vim-matchup",
        event = "BufRead",
        enabled = false,
        init = function()
            vim.g.matchup_override_vimtex = 1
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {}
            -- method = "popup",
            -- fullwidth = 0,
            -- syntax_hl = 1,
            -- }
        end,
    },

    -- { "chrisbra/csv.vim", ft = "csv" },

    { "jaredsampson/vim-pymol",      ft = "pml" },

    --{ "vim-pandoc/vim-pandoc" })
    --{ "vim-pandoc/vim-pandoc-syntax" })

    -- { dir = "/opt/local/lib/plumed/vim", ft = "plumed" },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre" },
        cmd = { "TSInstall", "TSUpdate" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "RRethy/nvim-treesitter-textsubjects",
            { "nvim-treesitter/nvim-treesitter-context", config = true },
        },
        config = function()
            require("treesitter-config")
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPost",
        config = function()
            require("plugins.indent-blankline")
        end,
    },

    -------------------------
    -- File, Fuzzy Finders --
    -------------------------
    {
        "nvim-neo-tree/neo-tree.nvim",
        enabled = true,
        cmd = { "Neotree" },
        keys = { "<leader>n" },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            vim.api.nvim_create_autocmd({ "BufEnter" }, {
                callback = function(args)
                    if vim.fn.isdirectory(args.match) == 1 then
                        require("lazy").load({ plugins = { "neo-tree.nvim" } })
                        vim.cmd("Neotree")
                        return true
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "SessionLoadPost" }, {
                callback = function(args)
                    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_get_name(buf):match("neo%-tree") then
                            -- print("neotreee!")
                            vim.api.nvim_buf_delete(buf, { force = true })
                            -- require("lazy").load({ plugins = { "neo-tree.nvim" } })
                            -- vim.cmd("Neotree")
                            return
                        end
                    end
                end,
            })
        end,
        branch = "v3.x",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "antosha417/nvim-lsp-file-operations",
            -- "miversen33/netman.nvim",
            {
                "s1n7ax/nvim-window-picker",
                config = function()
                    require("window-picker").setup({
                        autoselect_one = true,
                        include_current_win = false,
                        selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                        current_win_hl_color = "none",
                        other_win_hl_color = "none",
                        fg_color = "fg",
                        filter_rules = {
                            bo = {
                                -- filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                                buftype = { "terminal", "quickfix", "nofile" },
                            },
                        },
                    })
                end,
            },
        },
        config = function()
            -- require("netman").setup()
            require("plugins.neo-tree")
            require("lsp-file-operations").setup()
        end,
    },


    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = { "<leader>o" },
        config = function()
            require("oil").setup({
                default_file_explorer = false,
            })
            vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Oil" })
        end,
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

    --{ "ibhagwan/fzf-lua", requires = { "junegunn/fzf", run = "./install --bin" } })

    -------------------------------------------
    -- Colors, Icons, StatusLine, BufferLine --
    -------------------------------------------

    {
        "rebelot/kanagawa.nvim",
        dev = true,
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.o.background = nil
            local c = require("kanagawa.lib.color")
            -- vim.cmd("set bg=")
            vim.o.cmdheight = 0
            -- vim.o.pumblend = 10

            require("kanagawa").setup({
                compile = true,
                dimInactive = false,
                -- transparent = true,
                background = { light = "lotus", dark = "wave" },
                -- colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
                overrides = function(colors)
                    local theme = colors.theme
                    local function blend_bg(diag)
                        return { fg = diag, bg = c(diag):blend(theme.ui.bg, 0.95):to_hex() }
                    end

                    return {
                        TelescopeTitle = { fg = theme.ui.special, bold = true },
                        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
                        NormalFloat = { bg = "none" },
                        FloatTitle = { bg = "none" },
                        FloatBorder = { bg = "none" },
                        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
                        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                        PmenuSbar = { bg = theme.ui.bg_m1 },
                        PmenuThumb = { bg = theme.ui.bg_p2 },
                        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                        TroubleNormal = { link = "NormalDark" },
                        TroubleNormalNC = { link = "TroubleNormal" },
                        NeoTreeNormal = { link = "NormalDark" },
                        NeoTreeNormalNC = { link = "NeoTreeNormal" },
                        DiagnosticVirtualTextError = blend_bg(theme.diag.error),
                        DiagnosticVirtualTextWarn = blend_bg(theme.diag.warning),
                        DiagnosticVirtualTextHint = blend_bg(theme.diag.hint),
                        DiagnosticVirtualTextInfo = blend_bg(theme.diag.info),
                        DiagnosticVirtualTextOk = blend_bg(theme.diag.ok),
                        -- LspInlayHint = { fg = theme.ui.special },
                        -- EndOfBuffer = { link = 'NonText' }
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa")
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "kanagawa",
                callback = function()
                    if vim.o.background == "light" then
                        vim.fn.system("kitty +kitten themes Kanagawa_light")
                        -- vim.fn.system("~/.config/alacritty/switch_theme kanagawa_lotus.toml")
                    elseif vim.o.background == "dark" then
                        vim.fn.system("kitty +kitten themes Kanagawa_dragon")
                        -- vim.fn.system("~/.config/alacritty/switch_theme kanagawa_wave.toml")
                    end
                end,
            })
        end,
    },

    { "rebelot/lucy.nvim",  lazy = false, dev = true, enabled = false },

    {
        "kyazdani42/nvim-web-devicons",
        lazy = true,
        -- config = true,
        opts = {
            default = true,
        },
    },

    {
        "rebelot/heirline.nvim",
        dev = true,
        -- event = "VimEnter",
        event = "BufEnter",
        enabled = true,
        config = function()
            require("plugins.heirline")
        end,
    },

    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        opts = { bar_len = 60 },
        config = true,
    },

    --------------------------
    -- Editor Utilities, UI --
    --------------------------

    {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap-config")
        end,
    },

    {
        "jbyuki/one-small-step-for-vimkind",
        lazy = true,
        ft = "lua",
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
            "nvim-neotest/nvim-nio",
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
        config = true,
        opts = {
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = true,
            show_stop_reason = true,
            commented = false,
            virt_text_pos = "eol",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil,
        },
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
        event = "BufReadPre",
        config = function()
            require("plugins.gitsigns")
        end,
    },

    {
        "lewis6991/satellite.nvim",
        event = "BufReadPost",
        setup = true,
        enabled = false,
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
        keys = "<leader>mu",
        config = function()
            vim.keymap.set("n", "<leader>mu", "<cmd>MundoToggle<CR>", { desc = "Mundo: toggle" })
        end,
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
        -- Go Glepnir!
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        enabled = true,
        config = function()
            require("plugins.dashboard")
            vim.keymap.set("n", "<F3>", "<cmd>Dashboard<CR>", { desc = "Dashboard: open" })
        end,
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
        config = function()
            require("plugins.autopairs")
        end,
    },

    "wellle/targets.vim",

    {
        "michaeljsmith/vim-indent-object",
        keys = { { mode = "x", "ai" }, { mode = "x", "ii" }, { mode = "o", "ai" }, { mode = "o", "ii" } },
    },

    -- {"folke/flash.nvim"}
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
        keys = { { "<leader>vp" }, { mode = "x", "<leader>vs" } },
        cmd = { "VimuxPromptCommand", "VimuxOpenRunner" },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "python",
                command = [[xnoremap <buffer> <leader>vs "+y :call VimuxRunCommand('%paste')<CR>]],
            })
        end,
        config = function()
            vim.cmd([[
            function! VimuxSlime()
                call VimuxRunCommand(@v, 0)
            endfunction
            ]])
            vim.keymap.set("x", "<leader>vs", '"vy :call VimuxSlime()<CR>', { desc = "Vimux: send selection" })
            vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<CR>", { desc = "Vimux: prompt command" })
        end,
    },
}, {
    dev = { path = "~/usr/src" },
    performance = { rtp = { disabled_plugins = disabled_rtp_plugins } },
    rocks = {
        hererocks = true,
    },
})

-- vim.opt.rtp:append({
--     "/Users/laurenzi/usr/src/kanagawa.nvim",
--     "/Users/laurenzi/usr/src/heirline.nvim",
--     "/Users/laurenzi/usr/src/terminal.nvim",
-- })

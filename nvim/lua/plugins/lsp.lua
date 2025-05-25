return {
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
        config = true
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
        opts = {
            -- preview = { type = "float" },
            open_no_results = true,
            keys = {
                ["<Tab>"] = "fold_toggle",
            },
            icons = {
                kinds = require("lsp.init").symbol_icons,
            },
            modes = {
                symbols = {
                    win = {
                        size = 0.2,
                    },
                    filter = {
                        any = {
                            kind = {
                                "Variable",
                                "Class",
                                "Constructor",
                                "Enum",
                                "Field",
                                "Function",
                                "Interface",
                                "Method",
                                "Module",
                                "Namespace",
                                "Package",
                                "Property",
                                "Struct",
                                "Trait",
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require("trouble").setup(opts)
            local map = vim.keymap.set
            map("n", "<leader>xt", "<cmd>Trouble<CR>")
            map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
            map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
            map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>")
            map("n", "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=bottom win.relative=win win.size=.5<CR>")
            map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>")
            map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>")
        end,
    },

    {
        "danymat/neogen",
        cmd = "Neogen",
        config = true,
    },
}

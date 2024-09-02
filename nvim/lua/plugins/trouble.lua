local map = vim.keymap.set

require("trouble").setup({
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
})

map("n", "<leader>xt", "<cmd>Trouble<CR>")
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>")
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=bottom win.relative=win win.size=.5<CR>")
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>")
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>")
-- map("n", "<leader>xp", "<cmd>Trouble symbols toggle focus=true<CR><cmd>Trouble lsp toggle focus=false win.position=bottom win.relative=win win.size=.5<CR>")

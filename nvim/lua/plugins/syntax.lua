return {
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

    -- { "jaredsampson/vim-pymol", ft = "pml" },

    --{ "vim-pandoc/vim-pandoc" })
    --{ "vim-pandoc/vim-pandoc-syntax" })

    -- { dir = "/opt/local/lib/plumed/vim", ft = "plumed" },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        branch = "main",
        lazy = false,
        event = { "BufReadPre" },
        cmd = { "TSInstall", "TSUpdate" },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                branch = "main",
                config = function()
                    require("nvim-treesitter-textobjects").setup({
                        select = { lookahead = true },
                    })
                    local map = vim.keymap.set
                    local ts = require 'nvim-treesitter-textobjects.select'
                    local tw = require 'nvim-treesitter-textobjects.swap'
                    local tm = require 'nvim-treesitter-textobjects.move'
                    map({ 'x', 'o' }, "af", function() ts.select_textobject("@function.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "if", function() ts.select_textobject("@function.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "ac", function() ts.select_textobject("@class.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "ic", function() ts.select_textobject("@class.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "al", function() ts.select_textobject("@loop.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "il", function() ts.select_textobject("@loop.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "ik", function() ts.select_textobject("@block.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "ak", function() ts.select_textobject("@block.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "ia", function() ts.select_textobject("@parameter.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "aa", function() ts.select_textobject("@parameter.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "i=", function() ts.select_textobject("@assignment.inner", 'textobjects') end)
                    map({ 'x', 'o' }, "a=", function() ts.select_textobject("@assignment.outer", 'textobjects') end)
                    map({ 'x', 'o' }, "as", function() ts.select_textobject("@scope", "locals") end)
                    map('n', "<leader>ss", function() tw.swap_next("@parameter.inner") end)
                    map('n', "<leader>sf", function() tw.swap_next("@function.outer") end)
                    map('n', "<leader>sk", function() tw.swap_next("@block.outer") end)
                    map('n', "<leader>sS", function() tw.swap_next("@parameter.inner") end)
                    map('n', "<leader>sF", function() tw.swap_next("@function.outer") end)
                    map('n', "<leader>sK", function() tw.swap_next("@block.outer") end)
                    map({ 'n', 'x', 'o' }, "]f", function() tm.goto_next_start("@function.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]c", function() tm.goto_next_start("@class.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]k", function() tm.goto_next_start("@block.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]a", function() tm.goto_next_start("@parameter.inner", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]s", function() tm.goto_next_start("@scope", "locals") end)
                    map({ 'n', 'x', 'o' }, "]F", function() tm.goto_next_end("@function.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]C", function() tm.goto_next_end("@class.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]K", function() tm.goto_next_end("@block.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]A", function() tm.goto_next_end("@parameter.inner", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "]S", function() tm.goto_next_end("@scope", "locals") end)
                    map({ 'n', 'x', 'o' }, "[f", function() tm.goto_previous_start("@function.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[c", function() tm.goto_previous_start("@class.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[k", function() tm.goto_previous_start("@block.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[a", function() tm.goto_previous_start("@parameter.inner", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[s", function() tm.goto_previous_start("@scope", "locals") end)
                    map({ 'n', 'x', 'o' }, "[F", function() tm.goto_previous_end("@function.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[C", function() tm.goto_previous_end("@class.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[K", function() tm.goto_previous_end("@block.outer", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[A", function() tm.goto_previous_end("@parameter.inner", 'textobjects') end)
                    map({ 'n', 'x', 'o' }, "[S", function() tm.goto_previous_end("@scope", "locals") end)
                end
            },
            { "RRethy/nvim-treesitter-textsubjects",     enabled = false },
            { "nvim-treesitter/nvim-treesitter-context", config = true },
        },
        config = function()
            -- { "neomuttrc", "muttrc", "vim" }
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    -- if vim.tbl_contains({ "rust", "python", "lua", "sh", "markdown", }, vim.bo.filetype) then
                    if vim.bo.buftype == '' and not vim.tbl_contains({ "neomuttrc", "muttrc", "vim" }, vim.bo.filetype) then
                        if not vim.treesitter.language.add(vim.bo.filetype) then return end
                        vim.notify("starting treesitter for ft " .. vim.bo.filetype)
                        vim.treesitter.start()
                        vim.wo.foldmethod = "expr"
                        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPost",
        opts = {
            scope = { show_start = false, show_end = false },
            exclude = {
                buftypes = { "terminal", "prompt", "nofile" },
                filetypes = {
                    "help",
                    "dashboard",
                    "Trouble",
                    "dap.*",
                    "NvimTree",
                    "packer",
                },
            },
        }
    },
}

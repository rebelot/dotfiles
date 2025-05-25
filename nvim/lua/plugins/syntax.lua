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

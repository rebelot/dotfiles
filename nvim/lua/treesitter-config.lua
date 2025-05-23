require("nvim-treesitter.configs").setup({
    ensure_installed = "all", --  "all", "maintained" or a list
    ignore_install = {},      -- List of parsers to ignore installing
    highlight = {
        enable = true,        -- false will disable the whole extension
        disable = {"neomuttrc", "muttrc", "vim"},
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            node_decremental = "grN",
            scope_incremental = "grc",
        },
    },
    indent = {
        enable = false,
    },
    matchup = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ik"] = "@block.inner",
                ["ak"] = "@block.outer",
                ["ia"] = "@parameter.inner",
                ["aa"] = "@parameter.outer",
                ["i="] = "@assignment.inner",
                ["a="] = "@assignment.outer",
                ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" }
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>ss"] = "@parameter.inner",
                ["<leader>sf"] = "@function.outer",
                ["<leader>sk"] = "@block.outer",
            },
            swap_previous = {
                ["<leader>sS"] = "@parameter.inner",
                ["<leader>sF"] = "@function.outer",
                ["<leader>sK"] = "@block.outer",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]k"] = "@block.outer",
                ["]a"] = "@parameter.inner",
                ["]s"] = { query = "@scope", query_group = "locals" },
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]C"] = "@class.outer",
                ["]K"] = "@block.outer",
                ["]A"] = "@parameter.inner",
                ["]S"] = { query = "@scope", query_group = "locals" },
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[k"] = "@block.outer",
                ["[a"] = "@parameter.inner",
                ["[s"] = { query = "@scope", query_group = "locals" },
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[C"] = "@class.outer",
                ["[K"] = "@block.outer",
                ["[A"] = "@parameter.inner",
                ["[S"] = { query = "@scope", query_group = "locals" },
            },
        },
        lsp_interop = {
            enable = true,
            border = vim.g.FloatBorders,
            peek_definition_code = {
                ["<leader>lg"] = "@block.outer",
                -- ["<leader>lG"] = "@class.outer",
            },
        },
    },
    textsubjects = {
        enable = true,
        -- keymaps = {
        --     -- ["<C-L>"] = "textsubjects-smart", -- works in visual mode
        --     ['.'] = 'textsubjects-smart',
        --     [';'] = 'textsubjects-container-outer',
        --     ['i;'] = 'textsubjects-container-inner',
        -- },
    },
    playground = {
        enable = true,
    },
})


-- local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
-- local map = vim.keymap.set
-- map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
-- map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
-- map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
-- map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

--  @block.inner
--  @block.outer
--  @call.inner
--  @call.outer
--  @class.inner
--  @class.outer
--  @comment.outer
--  @conditional.inner
--  @conditional.outer
--  @frame.inner
--  @frame.outer
--  @function.inner
--  @function.outer
--  @loop.inner
--  @loop.outer
--  @parameter.inner
--  @parameter.outer
--  @scopename.inner
--  @statement.outer

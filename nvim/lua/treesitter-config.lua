
require('nvim-treesitter.configs').setup{
  ensure_installed = "maintained", --  "all", "maintained" or a list
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,      -- false will disable the whole extension
    disable = {'vim', 'sh', 'bash'},  -- list of language that will be disabled
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
    enable = false
  },
  matchup = {
      enable = true
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
          },
      },
      swap = {
          enable = true,
          swap_next = {
            ["<leader>ss"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>sS"] = "@parameter.inner",
          },
      },
      move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
      },
      lsp_interop = {
        enable = true,
        border = 'single',
        peek_definition_code = {
            ["<leader>lg"] = "@block.outer",
            -- ["<leader>lG"] = "@class.outer",
        },
    },
  },
}

-- Folding
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

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

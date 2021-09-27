local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

-- bootstap
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- autocompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Code completion {{{

  use 'neovim/nvim-lspconfig'
  -- use "ray-x/lsp_signature.nvim"
  -- use "simrat39/symbols-outline.nvim"
  use {'nvim-lua/lsp-status.nvim',
    config = function()
      require'lsp-status'.config{
        -- kind_labels = {},
        current_function = false,
        diagnostics = false,
        indicator_separator = '',
        component_separator = '',
        indicator_errors = ' ',
        indicator_warnings = ' ',
        indicator_info = ' ',
        indicator_hint = ' ',
        indicator_ok = ' ',
        spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'},
        -- status_symbol = '[LSP] ',
        status_symbol = '',
        -- select_symbol = nil,
        select_symbol = function(cursor_pos, symbol)
          if symbol.valueRange then
            local value_range = {
              ["start"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[1])
              },
              ["end"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[2])
              }
            }
            return require("lsp-status.util").in_range(cursor_pos, value_range)
          end
        end,
        update_interval = 100
      }
    end
  }
  use { "onsails/lspkind-nvim",
    config = function()
      require('lspkind').init({
        with_text = true,
        preset = 'codicons',
      })
    end
  }
  use {'hrsh7th/nvim-cmp',
    config = function() require "cmp-config" end,
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      { 'andersevenrud/compe-tmux', branch = 'cmp'},
      'quangnguyen30192/cmp-nvim-ultisnips'}
    }
  use {'liuchengxu/vista.vim',
    cmd = 'Vista',
    config = function()
      vim.g.vista_echo_cursor_strategy = 'floating_win'
      vim.g.vista_default_executive = 'ctags'
      vim.g.vista_ctags_executable = 'uctags'
      vim.g.vista_executive_for = {
          cpp = 'nvim_lsp',
          python = 'nvim_lsp',
          markdown = 'nvim_lsp',
          lua = 'nvim_lsp'
          }
    end
  }
  use {'SirVer/ultisnips',
    requires = {{'honza/vim-snippets', rtp = '.'}},
    config = function()
      -- vim.g.UltiSnipsExpandTrigger = '<c-j>'
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
      -- vim.g.UltiSnipsJumpForwardTrigger = '<c-j>'
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      -- vim.g.UltiSnipsJumpBackwardTrigger = '<c-k>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end
  }
  use {"folke/trouble.nvim",
    cmd = {'Trouble', 'Trouble*'},
    config = function()
      require'trouble'.setup{}
    end
  }
  -- use 'saadparwaiz1/cmp_luasnip'
  -- use 'L3MON4D3/LuaSnip'
  -- use 'hrsh7th/vim-vsnip'
  -- use "rafamadriz/friendly-snippets"
  -- use 'lervag/vimtex'
  -- }}}

  -- Syntax and Folds {{{
  -- use 'plasticboy/vim-markdown'
  use 'JuliaEditorSupport/julia-vim'
  use {'chrisbra/vim-zsh', ft='zsh'}
  use {'chrisbra/csv.vim', opt = true, cmd = 'CSVInit'}
  use {'vim-python/python-syntax',
    config = function()
      vim.g.python_highlight_all = 1
      vim.g.python_highlight_file_headers_as_comments = 1
      vim.g.python_highlight_space_errors = 0
    end
  }
  use {'tmhedberg/SimpylFold', ft='python'}
  use 'Konfekt/FastFold'
  use 'jaredsampson/vim-pymol'
  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-pandoc-syntax'
  -- use '/opt/plumed-2.4.3/lib/plumed/vim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
    config = function() require'treesitter-config' end }
  use {'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle'}
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  -- use 'neoclide/jsonc.vim'
  -- }}}

  -- File, Buffer Browsers {{{

  use {"kyazdani42/nvim-tree.lua", rtp = '.', config = function() require'nvim-tree-config' end}
  -- use {'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps'}
  -- use {'francoiscabrol/ranger.vim', cmd ={'Ranger'}}
  use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use {'junegunn/fzf.vim'}
  use {"nvim-telescope/telescope.nvim",
    config = function() require "telescope-config" end,
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}} }
  use {'nvim-telescope/telescope-dap.nvim', after = 'telescope.nvim',
    config = function() require('telescope').load_extension('dap') end
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', after = 'telescope.nvim', run = 'make',
    config = function() require('telescope').load_extension('fzf') end
  }
  use { "nvim-telescope/telescope-frecency.nvim", after = 'telescope.nvim',
  config = function() require"telescope".load_extension("frecency") end
  }
  use {"tami5/sqlite.lua", config = function() vim.g.sqlite_clib_path = "/opt/local/lib/libsqlite3.dylib" end}
  -- }}}

  -- Colors {{{
  -- use 'ryanoasis/vim-devicons'
  use {'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-web-devicons'.setup() end}
  -- use 'rktjmp/lush.nvim'
  -- use 'npxbr/gruvbox.nvim'
  use {'sainnhe/gruvbox-material', disable = true}
  use {'folke/tokyonight.nvim', disable = false}
  -- use 'gruvbox-community/gruvbox'
  -- use 'hoob3rt/lualine.nvim'
  -- use {'glepnir/galaxyline.nvim',
  --   config = function() require "galaxyline-config" end}
  use {'famiu/feline.nvim',
    config = function() require "feline-config" end}
  use {'akinsho/nvim-bufferline.lua',
    config = function() require "bufferline-config" end}
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
  -- use 'machakann/vim-highlightedyank'
  -- use 'RRethy/vim-illuminate'
  -- use 'andreypopp/vim-colors-plain'
  -- use 'lifepillar/vim-solarized8'
  -- use 'ajmwagar/vim-deus'
  -- use 'flazz/vim-colorschemes'
  -- use 'romainl/flattened'
  -- use 'nightsense/stellarized'
  -- use 'guns/xterm-color-table.vim'
  -- use 'nightsense/vrunchbang'
  -- use 'nightsense/seagrey'
  -- }}}

  -- Utils {{{
  use {'w0rp/ale',
    config = function()
      vim.g.ale_enabled = 0
      vim.g.ale_floating_preview = 1
      vim.g.ale_set_highlights = 1
      vim.g.ale_sign_error = '' --  ⤫
      vim.g.ale_sign_warning = '' -- ﯧ  ﯦ   ⚠    
      vim.g.ale_lint_on_text_changed = 'always'
      vim.g.ale_fixers = {python = 'autopep8', sh = 'shfmt'}
      vim.g.ale_linters = {python = {'flake8', 'pylint', 'mypy'}}
      vim.g.ale_python_mypy_options = '--ignore-missing-imports'
      vim.g.ale_python_pylint_options = '--disable=C'
      vim.g.ale_python_flake8_options = '--ignore=E221,E241,E201'
      vim.g.ale_virtualenv_dir_names = {'.env', '.venv', 'env', 've-py3', 've', 'virtualenv', 'venv', '.ve', 'venvs'}
      -- vim.cmd [[ let g:ale_pattern_options = {'\.py$': {'ale_enabled': 0}, '\.c[p]*$': {'ale_enabled': 0}, '\.vim$': {'ale_enabled': 0}} ]]
    end
  }
  use {'mfussenegger/nvim-dap',
    config = function()
      require'dap'
      vim.fn.sign_define('DapBreakpoint', {text=' ', texthl='debugBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='', texthl='debugBreakpoint', linehl='debugPC', numhl=''})
      require('dap.ext.vscode').load_launchjs()
      vim.g.dap_virtual_text = true
      vim.cmd [[au FileType dap-repl lua require('dap.ext.autocompl').attach()]]
    end
  }
  use {'mfussenegger/nvim-dap-python',
    config = function()
      require('dap-python').setup('~/venvs/debugpy/bin/python')
    end
  }
  use 'theHamsta/nvim-dap-virtual-text'
  use {'lewis6991/gitsigns.nvim',
    config = function()
      require'gitsigns'.setup{keymaps={}}
    end
  }
  use 'tpope/vim-fugitive'
  -- use 'mhinz/vim-signify'
  -- use 'ludovicchabant/vim-gutentags'
  use {'majutsushi/tagbar', cmd= {'TagbarToggle'}}
  use {'simnalamburt/vim-mundo', cmd = {'MundoToggle'}}
  use {'junegunn/vim-peekaboo',
    config = function() 
     vim.g.peekaboo_compact = 0
     vim.g.peekaboo_window = 'vert bo 30 new'
    end
  }
  -- use 'kassio/neoterm'
  use 'moll/vim-bbye'
  use 'lambdalisue/suda.vim'
  -- use {'wesQ3/vim-windowswap', config = function() g.windowswap_map_keys = 0 end }
  -- use 'fsharpasharp/nvim-historian'
  -- use 'neomake/neomake'
  use {'andymass/vim-matchup',
    config = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {method= 'popup'}
    end
  }
  -- use {'jmcantrell/vim-virtualenv', config = function() g.virtualenv_directory = '~/venvs/' end}
  use 'chrisbra/unicode.vim'
  -- use 'mhinz/vim-startify'
  use {'glepnir/dashboard-nvim', config = function() require'dashboard' end}
  use {'norcalli/nvim-colorizer.lua', config = function() require'colorizer'.setup() end}
  -- }}}

  -- Editing Tools {{{
  use {'godlygeek/tabular', cmd = {'Tabularize'}}
  use 'junegunn/vim-easy-align'
  use {'dhruvasagar/vim-table-mode', cmd = {'TableModeToggle'}}
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use {'raimondi/delimitmate',
    config = function()
      vim.g.delimitMate_expand_inside_quotes = 0
      vim.g.delimitMate_jump_expansion = 1
      vim.g.delimitMate_expand_cr = 2
      vim.g.delimitMate_expand_space = 1
      vim.g.delimitMate_nesting_quotes = {'"','`'}
    end
  }
  use 'wellle/targets.vim'
  use 'michaeljsmith/vim-indent-object'
  use 'justinmk/vim-sneak'
  use 'tpope/vim-repeat'
  use 'chrisbra/NrrwRgn'
  -- }}}

  -- Tmux {{{
  use 'benmills/vimux'
  use 'tmux-plugins/vim-tmux'
  -- use 'tmux-plugins/vim-tmux-focus-events'
  -- }}}

end)

-- vim:set sw=2 ts=2 fdm=marker:

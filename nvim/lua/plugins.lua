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

require('packer').init{max_jobs=50}
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Code completion {{{

  use 'neovim/nvim-lspconfig'
  -- use "ray-x/lsp_signature.nvim"
  use "simrat39/symbols-outline.nvim"
  use 'b0o/SchemaStore.nvim'
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
  use {"SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter",
    module = 'nvim-gps',
    config = function()
      require("nvim-gps").setup()
    end}
  use { "onsails/lspkind-nvim",
    config = function()
      require('lspkind').init({
        with_text = true,
        -- preset = 'codicons',
      })
    end
  }
  use {'hrsh7th/nvim-cmp', as = 'cmp',
    config = function() require "cmp-config" end,
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      'uga-rosa/cmp-dictionary',
      "kdheepak/cmp-latex-symbols",
      'dmitmel/cmp-cmdline-history',
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
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end
  }
  use {"folke/trouble.nvim",
    config = function()
      require'trouble'.setup{use_lsp_diagnostic_signs = true}
      vim.api.nvim_set_keymap('n', '<leader>xx', '<cmd>TroubleToggle<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xD', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xd', '<cmd>TroubleToggle lsp_document_diagnostics<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xc', '<cmd>TroubleToggle quickfix<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xl', '<cmd>TroubleToggle loclist<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xr', '<cmd>TroubleToggle lsp_references<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xn', '<cmd>lua pcall(require("trouble").next, {skip_groups = true, jump = true})<CR>', {noremap=true})
      vim.api.nvim_set_keymap('n', '<leader>xp', '<cmd>lua pcall(require("trouble").previous, {skip_groups = true, jump = true})<CR>', {noremap=true})
      vim.cmd [[
        augroup trouble_au
        autocmd!
        autocmd FileType Trouble setl cursorline 
        augroup END
      ]]
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
  use {"lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup {
        buftype_exclude = {"terminal", "prompt", "nofile"},
        filetype_exclude = {'help', 'dashboard', 'Trouble', 'dap.*', 'NvimTree', "packer"},
        show_current_context = true,
        show_current_context_start = false,
        use_treesitter = true,
        context_patterns = {'class', 'function', 'method', '.*_statement', 'table'}
      }
  end
}
  -- use 'neoclide/jsonc.vim'
  -- }}}

  -- File, Buffer Browsers {{{

  use {"kyazdani42/nvim-tree.lua", rtp = '.',
    config = function()
      require'nvim-tree-config'
      vim.api.nvim_set_keymap('n', "<leader>nt", "<cmd>NvimTreeToggle<CR>", {noremap=true})
      vim.api.nvim_set_keymap('n', "<leader>nf", "<cmd>NvimTreeFindFile<CR>", {noremap=true})
    end}
  -- use {'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps'}
  -- use {'francoiscabrol/ranger.vim', cmd ={'Ranger'}}
  use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use {'junegunn/fzf.vim'}
  use {"nvim-telescope/telescope.nvim",
    config = function()
      require "telescope-config"
			vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {noremap=true})
			-- vim.api.nvim_set_keymap("n", "<leader>fF", ":Telescope find_files cwd=", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>f.", "<cmd>Telescope file_browser<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fr", "<cmd>Telescope frecency<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader><space>", "<cmd>Telescope commands<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>T", "<cmd>Telescope<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Telescope spell_suggest<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", {noremap=true})
			vim.api.nvim_set_keymap("n", '<leader>t"', "<cmd>Telescope registers<CR>", {noremap=true})
			vim.cmd [[ command! -nargs=1 -complete=dir FindFiles Telescope find_files cwd=<args>]]
			vim.api.nvim_set_keymap("n", "<leader>fF", ":FindFiles ", {noremap=true})
		  -- nnoremap <leader>tr :Telescope lsp_references<CR>
		  -- nnoremap <leader>ts :Telescope lsp_document_symbols<CR>
    end,
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}} }
  use {'nvim-telescope/telescope-dap.nvim', after = {'telescope.nvim', 'nvim-dap'},
    config = function() require('telescope').load_extension('dap') end
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', after = 'telescope.nvim', run = 'make',
    config = function() require('telescope').load_extension('fzf') end
  }
  use { "nvim-telescope/telescope-frecency.nvim", after = {'telescope.nvim', 'sqlite.lua'},
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
  -- use 'sainnhe/gruvbox-material'
  use 'folke/tokyonight.nvim'
  use {"catppuccin/nvim", as = "catppuccin"}
  -- use 'rmehri01/onenord.nvim'
  -- use 'arcticicestudio/nord-vim'
  -- use "projekt0n/github-nvim-theme"
  -- use 'gruvbox-community/gruvbox'
  use {'famiu/feline.nvim',
    config = function() require "feline-config" end}
  use {'akinsho/nvim-bufferline.lua',
    config = function() require "bufferline-config" end}
  use 'junegunn/goyo.vim'
  use 'junegunn/limelight.vim'
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
  use {'mfussenegger/nvim-dap', config = function() require'dap-config' end }
  use {'mfussenegger/nvim-dap-python', after = 'nvim-dap',
    config = function()
      require('dap-python').setup('~/venvs/debugpy/bin/python')
    end
  }
  use {'theHamsta/nvim-dap-virtual-text', after = 'nvim-dap',
    config = function()
      require("nvim-dap-virtual-text").setup {
          enabled = true,                     -- enable this plugin (the default)
          enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = true,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,            -- show stop reason when stopped for exceptions
          commented = false,                  -- prefix virtual text with comment string
          -- experimental features:
          virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,                 -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
      }
    end
  }
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"},
    module = 'dapui',
    config = function()
      require("dapui").setup()
    end}
  use {'lewis6991/gitsigns.nvim', wants={"trouble"},
    config = function()
      require'gitsigns'.setup{trouble=true, keymaps={}}
        vim.api.nvim_set_keymap('n', '<leader>hd', '<cmd>Gitsigns preview_hunk<CR>', {noremap=true})
        vim.api.nvim_set_keymap('n', ']h', '<cmd>Gitsigns next_hunk<CR>', {noremap=true})
        vim.api.nvim_set_keymap('n', '[h', '<cmd>Gitsigns prev_hunk<CR>', {noremap=true})
        vim.api.nvim_set_keymap('n', '<leader>xh', '<cmd>Gitsigns setloclist<CR>', {noremap=true}) -- use trouble
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
  -- use 'tpope/vim-commentary'
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }
  use {'tpope/vim-surround'}
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
  use {"windwp/nvim-autopairs", after={'hop', 'cmp'},
    config = function()
      require('nvim-autopairs').setup{
        fast_wrap = {
          chars = { '{', '[', '(', '"', "'", '`' },
          map = '<M-l>',
          keys = "asdfghjklqwertyuiop",
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,%:] ]], '%s+', ''),
          end_key = 'L',
          highlight = 'HopNextKey',
          hightlight_grey= 'HopUnmatched'
        },
        check_ts = true,
        enable_check_bracket_line = false
      }
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = { tex = '' }}))

      function EscapePair()
        local closers = {")", "]", "}", ">", "'", '"', "`", ","}
        local line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        local after = line:sub(col + 1, -1)
        local closer_col = #after + 1
        local closer_i = nil
        for i, closer in ipairs(closers) do
          local cur_index, _ = after:find(closer)
          if cur_index and (cur_index < closer_col) then
            closer_col = cur_index
            closer_i = i
          end
        end
        if closer_i then
          vim.api.nvim_win_set_cursor(0, {row, col + closer_col})
        else
          vim.api.nvim_win_set_cursor(0, {row, col + 1})
        end
      end
      vim.api.nvim_set_keymap('i', '<C-l>', '<cmd>lua EscapePair()<CR>', {noremap=true, silent=true})
  end}
  use 'wellle/targets.vim'
  use 'michaeljsmith/vim-indent-object'
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
  use {
  'phaazon/hop.nvim',
  as = 'hop',
  disable = false,
  rtp = '.',
  config = function()
    -- local ac = require'hop.hint'.HintDirection['AFTER_CURSOR']
    -- local bc = require'hop.hint'.HintDirection['BEFORE_CURSOR']

    vim.api.nvim_set_keymap('n', 's', "<cmd>lua require'hop'.hint_char1()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('x', 's', "<cmd>lua require'hop'.hint_char1()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('o', 'x', "<cmd>lua require'hop'.hint_char1()<cr>", {noremap=true})

    vim.api.nvim_set_keymap('n', '<C-s>', "<cmd>lua require'hop'.hint_char2()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('x', '<C-s>', "<cmd>lua require'hop'.hint_char2()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('o', '<C-x>', "<cmd>lua require'hop'.hint_char2()<cr>", {noremap=true})

    vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_lines()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('x', 'SS', "<cmd>lua require'hop'.hint_lines()<cr>", {noremap=true})
    vim.api.nvim_set_keymap('o', 'X', "<cmd>lua require'hop'.hint_lines()<cr>", {noremap=true})
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup({teasing = false})
  end}
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

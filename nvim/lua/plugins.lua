local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Code completion {{{

  -- use {'neoclide/coc.nvim', branch = 'release'} 
  -- use 'antoinemadec/coc-fzf'

  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  -- use 'hrsh7th/nvim-compe'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  -- use 'hrsh7th/cmp-vsnip'
  use { 'andersevenrud/compe-tmux', branch = 'cmp'}
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  -- use "ray-x/lsp_signature.nvim"
  use 'JuliaEditorSupport/julia-vim'
  use 'liuchengxu/vista.vim'
  -- use "simrat39/symbols-outline.nvim"
  use 'honza/vim-snippets'
  use 'SirVer/ultisnips'
  use "folke/trouble.nvim"
  -- use 'saadparwaiz1/cmp_luasnip'
  -- use 'L3MON4D3/LuaSnip'
  -- use 'hrsh7th/vim-vsnip'
  -- use "rafamadriz/friendly-snippets"
  -- use 'lervag/vimtex'
  -- }}}

  -- Syntax and Folds {{{
  -- use 'plasticboy/vim-markdown'
  use 'chrisbra/vim-zsh'
  use {'chrisbra/csv.vim', opt = true, cmd = {'CSVInit' }}
  use 'vim-python/python-syntax'
  use 'tmhedberg/SimpylFold'
  use 'Konfekt/FastFold'
  use 'jaredsampson/vim-pymol'
  use 'vim-pandoc/vim-pandoc'
  use 'vim-pandoc/vim-pandoc-syntax'
  -- use '/opt/plumed-2.4.3/lib/plumed/vim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  -- use 'neoclide/jsonc.vim'
  -- }}}

  -- File, Buffer Browsers {{{

  use "kyazdani42/nvim-tree.lua"
  -- use {'ms-jpq/chadtree', branch = 'chad', run = 'python3 -m chadtree deps'}
  -- use {'francoiscabrol/ranger.vim', cmd ={'Ranger'}}
  use {'junegunn/fzf', dir = '~/.fzf', run = './install --all' }
  use {'junegunn/fzf.vim'}
  use {"nvim-telescope/telescope.nvim",
      requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}} }
  use 'nvim-telescope/telescope-dap.nvim'
  -- }}}

  -- Colors {{{
  -- use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'
  -- use 'rktjmp/lush.nvim'
  -- use 'npxbr/gruvbox.nvim'
  use 'sainnhe/gruvbox-material'
  -- use 'gruvbox-community/gruvbox'
  use 'hoob3rt/lualine.nvim'
  use 'akinsho/nvim-bufferline.lua'
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
  use 'w0rp/ale'
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'lewis6991/gitsigns.nvim'
  use 'tpope/vim-fugitive'
  -- use 'mhinz/vim-signify'
  -- use 'ludovicchabant/vim-gutentags'
  use {'majutsushi/tagbar', cmd= {'TagbarToggle'}}
  use {'simnalamburt/vim-mundo', cmd = {'MundoToggle'}}
  use 'junegunn/vim-peekaboo'
  -- use 'kassio/neoterm'
  use 'moll/vim-bbye'
  use 'lambdalisue/suda.vim'
  -- use 'wesQ3/vim-windowswap'
  -- use 'fsharpasharp/nvim-historian'
  -- use 'neomake/neomake'
  use 'andymass/vim-matchup'
  -- use 'jmcantrell/vim-virtualenv'
  use 'chrisbra/unicode.vim'
  use 'mhinz/vim-startify'
  -- }}}

  -- Editing Tools {{{
  use {'godlygeek/tabular', cmd = {'Tabularize'}}
  use 'junegunn/vim-easy-align'
  use {'dhruvasagar/vim-table-mode', cmd = {'TableModeToggle'}}
  use 'tpope/vim-commentary'
  use 'tpope/vim-surround'
  use 'raimondi/delimitmate'
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

end)

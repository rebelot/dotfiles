# Dotfiles

My configuration files for various stuff.

![my setup](screenshot.png)

## Neovim

### Main Features:

IDE:
- **LSP** code completion with **Snippets** support (lspconfig, nvim-cmp, UltiSnips)
- **Diagnostics** and **CodeActions** with null-ls
- **Debugger** (nvim-dap, nvim-dap-ui, nvim-dap-virtual-text)
- **Tests** (vim-ultest) with debbugging support (python)
- **Git** (fugitive + gitsigns)

UI:
- **TreeSitter** grammar (nvim-treesitter with text objects + nvim-gps)
- **Fuzzy Browser UI** (Telescope)
- **File explorer** (nvim-tree)
- **Statusline** with integrations for Spelling, Vi Mode + Snippets, LSPs, CWD, Git, Debugging, TreeSitter, Testing, Terminal modes, QickFix and special buffers (feline)
- **Undotree** (vim-mundo)
- Tags and LSP **symbols outline** (Tagbar, Vista and SymbolsOutline)

## Installation

```bash
cd $HOME
git clone https://github.com/rebelot/dotfiles
ln -s $HOME/dotfiles/zsh .zsh
ln -s $HOME/dotfiles/zshrc .zshrc
ln -s $HOME/dotfiles/tmux.conf .tmux.conf
ln -s $HOME/dotfiles/kitty.conf .config/kitty/
ln -s $HOME/dotfiles/nvim .config/
ln -s $HOME/dotfiles/bat .config/
ln -s $HOME/dotfiles/karabiner.json .config/karabiner/
ln -s $HOME/dotfiles/vimrc .vimrc

lesskey dotfiles/lesskey
/usr/bin/tic -x dotfiles/tmux-256color.terminfo
```

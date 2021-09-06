# Dotfiles

My configuration files for various stuff.

![my setup](screenshot.png)


## Terminfo
make sure terminfo specs are written to `$HOME/.terminfo`

```bash
unset TERMINFO
infocmp tmux-256color > tmux-256color.terminfo  # or fetch it elsewhere
/usr/bin/tic tmux-256color.terminfo
/usr/bin/tic -x ./tmux-256color.terminfo
```

## Lesskey

```bash
lesskey ./lesskey
```

## Tmux
see `terminal-overrides` option in `tmux.conf`

## Installation

```bash
cd $HOME
git clone https://github.com/rebelot/dotfiles
makedir -p ~/.config/nvim
cd dotfiles
ln -s zsh ~/.zsh
ln -s zshrc ~/.zshrc
ln -s tmux.conf ~/.tmux.conf
ln -s nvim/init.lua ~/.config/nvim/init.lua
ln -s nvim/lua ~/.config/nvim/lua
ln -s nvim/viml ~/.config/nvim/viml
ln -s kitty.conf ~/.config/kitty/kitty.conf
```

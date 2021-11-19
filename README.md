# Dotfiles

My configuration files for various stuff.

![my setup](screenshot.png)

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

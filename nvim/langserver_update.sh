#!/bin/bash
# pyright, vim-language-server, bash-language-server, 
yarn global upgrade

# texlab
cargo install --git https://github.com/latex-lsp/texlab.git --locked

# efm
go install 'github.com/mattn/efm-langserver@latest'

# ccls
# macports ccls-clang-11

# sumneko_lua
cd $HOME/usr/src
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild

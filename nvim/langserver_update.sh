#!/bin/bash
# pyright, vim-language-server, bash-language-server, vscode-html-language-server vscode-css-language-server vscode-json-language-server vscode-eslint-language-server
yarn global upgrade

# texlab
cargo install --git https://github.com/latex-lsp/texlab.git --locked

# efm
go install 'github.com/mattn/efm-langserver@latest'

# ccls
# port upgrade ccls-clang-11

cd "$HOME/usr/src/ccls" || exit
git pull
rm -rf Release
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/Users/laurenzi/usr/src/clang+llvm-13.0.0-x86_64-apple-darwin
cmake --build Release

# sumneko_lua
cd "$HOME/usr/src" || exit
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server || exit
git submodule update --init --recursive
cd 3rd/luamake || exit
compile/install.sh
cd ../.. || exit
./3rd/luamake/luamake rebuild

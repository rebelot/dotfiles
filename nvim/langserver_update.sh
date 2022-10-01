#!/bin/bash

# pyright
# vim-language-server
# bash-language-server
# vscode-html-language-server
# vscode-css-language-server
# vscode-json-language-server
# vscode-eslint-language-server
yarn global upgrade

# texlab, stylua
cargo install --git https://github.com/latex-lsp/texlab.git --locked
cargo instal stylua

# sumneko_lua
# https://github.com/sumneko/lua-language-server/releases/latest
# port upgrade lua-language-server

# ccls
# cppcheck
# \shellcheck
# port selfupdate && port upgrade outdated

cd "$HOME/usr/src/ccls" || exit
git pull
rm -rf Release
# cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/Users/laurenzi/usr/src/clang+llvm-13.0.0-x86_64-apple-darwin
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/local/libexec/llvm-14
cmake --build Release

# ltex-ls
# https://github.com/valentjn/ltex-ls/releases

# marksman
# https://github.com/artempyanykh/marksman/releases/

# vscode-lldb
# https://github.com/vadimcn/vscode-lldb/releases

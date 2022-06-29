#!/bin/bash
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua

# Neovim
ln -sf $(pwd)/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf $(pwd)/nvim/lua/config.lua $HOME/.config/nvim/lua/config.lua

# Vim
ln -sf $(pwd)/nvim/init.vim $HOME/.vimrc
ln -sf $(pwd)/.vim $HOME/.vim

ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf

ln -sf $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -sf $(pwd)/zsh/.zsh_alias $HOME/.zsh_alias


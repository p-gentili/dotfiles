#!/bin/bash

# Neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
ln -sf $(pwd)/.vimrc $HOME/.config/nvim/init.vim
ln -sf $(pwd)/nvim/lua/config.lua $HOME/.config/nvim/lua/config.lua

# Vim
mkdir ~/.vim
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/vim/coc-settings.json $HOME/.vim/coc-settings.json
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# ZSH
ln -sf $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -sf $(pwd)/zsh/.zsh_alias $HOME/.zsh_alias

# Other apps
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -sf $(pwd)/foot $HOME/.config/foot
ln -sf $(pwd)/helix $HOME/.config/helix
ln -sf $(pwd)/sway $HOME/.config/sway
ln -sf $(pwd)/waybar $HOME/.config/waybar
ln -sf $(pwd)/zellij $HOME/.config/zellij

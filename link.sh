#!/bin/bash
set -x

# Neovim
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua
ln -sf $(pwd)/.vimrc $HOME/.config/nvim/init.vim
ln -sf $(pwd)/nvim/lua/config.lua $HOME/.config/nvim/lua/config.lua

# Vim
mkdir -p ~/.vim
ln -sf $(pwd)/.vimrc $HOME/.vimrc
ln -sf $(pwd)/vim/coc-settings.json $HOME/.vim/coc-settings.json
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Binaries
mkdir -p ~/.local/bin
chmod +x $(pwd)/.local/bin/*
ln -snf $(pwd)/.local/bin/* ~/.local/bin

# ZSH
ln -sf $(pwd)/zsh/.zshrc $HOME/.zshrc
ln -sf $(pwd)/zsh/.zsh_alias $HOME/.zsh_alias

# OpenCode
mkdir -p ~/.config/opencode
ln -sf $(pwd)/opencode/opencode.jsonc $HOME/.config/opencode/opencode.jsonc

# Other apps
ln -sf $(pwd)/.tmux.conf $HOME/.tmux.conf
ln -snf $(pwd)/foot $HOME/.config/foot
ln -snf $(pwd)/helix $HOME/.config/helix
ln -snf $(pwd)/sway $HOME/.config/sway
ln -snf $(pwd)/waybar $HOME/.config/waybar
ln -snf $(pwd)/zellij $HOME/.config/zellij
ln -snf $(pwd)/kitty $HOME/.config/kitty
ln -snf $(pwd)/mako $HOME/.config/mako
ln -snf $(pwd)/wofi $HOME/.config/wofi
ln -snf $(pwd)/swaylock $HOME/.config/swaylock

# Seed active-theme pointers (gitignored; theme-apply repoints them at runtime)
ln -snf colors-latte.css $(pwd)/waybar/colors.css
ln -snf theme-latte.conf $(pwd)/sway/theme.conf
ln -snf style-latte.css  $(pwd)/wofi/style.css
ln -snf config-latte     $(pwd)/swaylock/config
ln -snf config-latte     $(pwd)/mako/config

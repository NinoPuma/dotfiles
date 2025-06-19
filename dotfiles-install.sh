#!/bin/bash
echo "Instalando dotfiles de Kitty y Neovim de NinoPuma"

mkdir -p ~/.config/kitty
cp -r ./kitty/* ~/.config/kitty/

mkdir -p ~/.config/nvim
cp -r ./nvim/* ~/.config/nvim/

echo "Configs copiadas en ~/.config/"

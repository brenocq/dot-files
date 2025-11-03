#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
SHARED_FOLDER="$SCRIPT_PATH/shared"
ARCH_FOLDER="$SCRIPT_PATH/arch"

echo "Deleting $ARCH_FOLDER"
rm -r $SHARED_FOLDER
mkdir $SHARED_FOLDER
mkdir $SHARED_FOLDER/.config
rm -r $ARCH_FOLDER
mkdir $ARCH_FOLDER
mkdir $ARCH_FOLDER/.config
mkdir $ARCH_FOLDER/fonts
mkdir $ARCH_FOLDER/wallpapers

##### Shared configs #####

# Neovim
echo "Copying .config/nvim/"
cp -R ~/.config/nvim $SHARED_FOLDER/.config
rm $SHARED_FOLDER/.config/nvim/lazy-lock.json

# Kitty
echo "Copying .config/kitty/"
cp -R ~/.config/kitty $SHARED_FOLDER/.config

# Git
echo "Copying .gitconfig"
cp ~/.gitconfig $SHARED_FOLDER

# Starship
echo "Copying .config/starship.toml"
cp ~/.config/starship.toml $SHARED_FOLDER/.config

##### Arch-specific configs #####

# Hyprland
echo "Copying .config/hypr/"
cp -R ~/.config/hypr $ARCH_FOLDER/.config

# Fish
echo "Copying .config/fish/"
mkdir $ARCH_FOLDER/.config/fish
cp ~/.config/fish/config.fish $ARCH_FOLDER/.config/fish

# TMUX
echo "Copying .config/tmux/"
cp -R ~/.config/tmux $ARCH_FOLDER/.config

# Fonts
echo "Copying fonts"
cp ~/.local/share/fonts/feather.ttf $ARCH_FOLDER/fonts

# Wallpapers
echo "Copying wallpapers"
cp ~/Pictures/wallpapers/* $ARCH_FOLDER/wallpapers

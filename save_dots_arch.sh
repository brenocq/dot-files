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

# XInit
echo "Copying .xinitrc"
cp ~/.xinitrc $ARCH_FOLDER/

# I3
echo "Copying .config/i3/"
cp -R ~/.config/i3 $ARCH_FOLDER/.config

# Picom
echo "Copying .config/picom/"
cp -R ~/.config/picom $ARCH_FOLDER/.config

# Polybar
echo "Copying .config/polybar/"
cp -R ~/.config/polybar $ARCH_FOLDER/.config

# Rofi
echo "Copying .config/rofi/"
cp -R ~/.config/rofi $ARCH_FOLDER/.config

# Fish
echo "Copying .config/fish/"
mkdir $ARCH_FOLDER/.config/fish
cp ~/.config/fish/config.fish $ARCH_FOLDER/.config/fish

# TMUX
echo "Copying .config/tmux/"
cp ~/.config/tmux/tmux.conf $ARCH_FOLDER/.config/tmux

# Fonts
echo "Copying fonts"
cp ~/.local/share/fonts/feather.ttf $ARCH_FOLDER/fonts

# Wallpapers
echo "Copying wallpapers"
cp ~/Pictures/wallpapers/* $ARCH_FOLDER/wallpapers

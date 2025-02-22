#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
ARCH_FOLDER="$SCRIPT_PATH/arch"

echo "Deleting $ARCH_FOLDER"
rm -r $ARCH_FOLDER
mkdir $ARCH_FOLDER
mkdir $ARCH_FOLDER/.config
mkdir $ARCH_FOLDER/.config/nvim
mkdir $ARCH_FOLDER/fonts
mkdir $ARCH_FOLDER/wallpapers

# XInit
echo "Copying .xinitrc"
cp ~/.xinitrc $ARCH_FOLDER/

# Neovim
echo "Copying .config/nvim/"
cp -R ~/.config/nvim $ARCH_FOLDER/.config

# I3
echo "Copying .config/i3/"
cp -R ~/.config/i3 $ARCH_FOLDER/.config

# Kitty
echo "Copying .config/kitty/"
cp -R ~/.config/kitty $ARCH_FOLDER/.config

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
cp -R ~/.config/fish $ARCH_FOLDER/.config
rm $ARCH_FOLDER/.config/fish/fish_plugins
rm $ARCH_FOLDER/.config/fish/fish_variables

# Starship
echo "Copying .config/starship.toml"
cp ~/.config/starship.toml $ARCH_FOLDER/.config

# Fonts
echo "Copying fonts"
cp ~/.local/share/fonts/feather.ttf $ARCH_FOLDER/fonts

# Wallpapers
echo "Copying wallpapers"
cp ~/Pictures/wallpapers/* $ARCH_FOLDER/wallpapers

# Git
echo "Copying .gitconfig"
cp ~/.gitconfig $ARCH_FOLDER

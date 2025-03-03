#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
SHARED_FOLDER="$SCRIPT_PATH/shared"
MACOS_FOLDER="$SCRIPT_PATH/macos"

echo "Deleting $ARCH_FOLDER"
rm -r $SHARED_FOLDER
mkdir $SHARED_FOLDER
mkdir $SHARED_FOLDER/.config
rm -r $MACOS_FOLDER
mkdir $MACOS_FOLDER

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

##### MacOS-specific configs #####

# Zsh
echo "Copying .zshrc"
cp ~/.zshrc $MACOS_FOLDER/

#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
SHARED_FOLDER="$SCRIPT_PATH/shared"

# Update package lists and install core packages
echo "Updating package lists and installing core packages..."
sudo apt update
sudo apt upgrade
sudo apt install -y cmake git neovim neofetch starship ripgrep
echo "Finished installing core packages"

# Copy configs
echo "Copying Configs..."
cp -r "$SHARED_FOLDER/.config" "$HOME/"
cp "$SHARED_FOLDER/.gitconfig" "$HOME/"
echo "Finished Copying Configs"

# Install kitty
echo "Installing kitty terminal..."
sudo apt install -y kitty
echo "Finished installing kitty terminal"

# Install powerline fonts (if needed for Starship)
echo "Installing powerline fonts..."
sudo apt install -y fonts-powerline
echo "Finished installing powerline fonts"

# Install build essential
echo "Installing build essential."
sudo apt install -y build-essential
echo "Finished installing build essential."

# Finished
echo "Ubuntu setup completed successfully!"

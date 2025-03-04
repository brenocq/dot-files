#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
SHARED_FOLDER="$SCRIPT_PATH/shared"
MACOS_FOLDER="$SCRIPT_PATH/macos"

# Install core packages using Homebrew
echo "Installing brew packages..."
brew install cmake git neovim neofetch starship
brew install ripgrep # Dependency for nvim telescope grep
echo "Finished installing brew packages"

# Copy configs
echo "Copying Configs..."
cd $SHARED_FOLDER
cp -R .config/ .gitconfig ~/
cd $MACOS_FOLDER
cp .zshrc ~/
echo "Finished Copying Configs"

# Install kitty
echo "Installing kitty terminal..."
brew install --cask kitty
echo "Finished installing kitty terminal"

# Finished
echo "macOS setup completed successfully!"

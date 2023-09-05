#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT` 
ARCH_FOLDER="$SCRIPT_PATH/arch"

# Downloading theme packages
echo "Downloading environment packages..."
yay -Sy i3-gaps kitty picom-pijulius-git polybar rofi ranger fish
yay -Sy nerd-fonts-roboto-mono ttf-roboto-mono ttf-joypixels
echo "Finished downloading packages"

# Copy configs
echo "Copying Configs..."
cd $ARCH_FOLDER
cp -R .vim/ .config/ .gitconfig .xinitrc ~/
echo "Finished Copying Configs"

# Copy fonts
mkdir -p ~/.local/share/fonts/
cp fonts/* ~/.local/share/fonts/

# Copy wallpapers
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers

# Config terminal
chsh -s /usr/bin/fish

# Install vim Plug
echo "Installing vim plug..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa
echo "Finished installing vim plug"

# Install starship
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh
echo "Finished installing starship"

# Downloading utils packages
echo "Downloading utils packages..."
sudo pacman -Sy yay
yay -Sy cmake gdb jump fortune-mod cowsay flameshot peek autorandr gotop mpv feh arandr

# Download applications
yay -Sy google-chrome zotero-bin spotify discord_arch_electron

# Setup bluetooth headset
yay -Sy bluez-utils alsa-utils

# Finished
echo "Done with setting up environment"

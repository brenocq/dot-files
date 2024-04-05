#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT` 
ARCH_FOLDER="$SCRIPT_PATH/arch"

# Download core packages
echo "Downloading core packages..."
yay -Sy xorg-server i3-gaps kitty picom-pijulius-git polybar rofi ranger fish
yay -Sy git gvim
yay -Sy nerd-fonts-roboto-mono ttf-roboto-mono ttf-joypixels ttf-nerd-fonts-symbols
echo "Finished downloading packages"

# Download NVIDIA driver
echo "Downloading NVDIA packages..."
yay -Sy nvidia
echo "Finished downloading NVIDIA package"

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
yay -Sy google-chrome zotero-bin spotify discord_arch_electron telegram-desktop-bin

# Fix bluetooth
yay -Sy bluez bluez-utils alsa-utils
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Fix wifi
yay -Sy networkmanager
sudo systemctl enable --now NetworkManager

# X
yay -Sy xorg-xinit

# C++
yay -Sy cppcheck clang

# Embedded
yay -Sy arm-none-eabi-gcc arm-none-eabi-newlib arm-none-eabi-gdb stlink

# Git
git config --global core.pager "vim -R -c 'set filetype=diff' -"

# Latex
yay -Sy pdfpc
#yay -Sy texlive-full <- Takes a long time

# Finished
echo "Done with setting up environment"

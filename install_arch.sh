#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT` 
ARCH_FOLDER="$SCRIPT_PATH/arch"

# Downloading theme packages
echo "Downloading environment packages..."
sudo pacman -Sy i3-gaps kitty picom-pijulius-git polybar rofi nerd-fonts-roboto-mono ttf-roboto-mono tty-joypixels ranger fish
echo "Finished downloading packages"

# Copy configs
echo "Copying Configs..."
cd $ARCH_FOLDER
cp -R .vim/ .config/ ~/
echo "Finished Copying Configs"

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
yay -Sy cmake gdb firefox jump fortune cowsay

# Finished
echo "Done with setting up environment"

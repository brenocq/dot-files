#!/bin/bash

# Downloading packages
echo "Downloading packages"
sudo pacman -Sy i3-gaps rxvt-unicode picom polybar 
echo "Finished downloading packages"

# Copy configs
echo "Copying Configs"
cd arch/
cp -R .bashrc .vim/ .config/ .Xresources ~/
echo "Finished Copying Configs"

# Install vim Plug
echo "Installing vim plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa
echo "Finished installing vim plug"

echo "Done with setting up environment"

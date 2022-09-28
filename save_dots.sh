#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT` 
ARCH_FOLDER="$SCRIPT_PATH/arch"

echo "Deleting $ARCH_FOLDER"
rm -r $ARCH_FOLDER
mkdir $ARCH_FOLDER

echo "Copying .vim/"
mkdir $ARCH_FOLDER/.vim
cp ~/.vim/vimrc $ARCH_FOLDER/.vim/vimrc
cp -R ~/.vim/syntax $ARCH_FOLDER/.vim/

echo "Copying .config/i3/"
cp -R ~/.config/i3 $ARCH_FOLDER

echo "Copying .config/kitty/"
cp -R ~/.config/kitty $ARCH_FOLDER

echo "Copying .config/picom/"
cp -R ~/.config/picom $ARCH_FOLDER

echo "Copying .config/polybar/"
cp -R ~/.config/polybar $ARCH_FOLDER

echo "Copying .config/rofi/"
cp -R ~/.config/rofi $ARCH_FOLDER

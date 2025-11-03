#!/bin/bash

SCRIPT=`realpath $0`
SCRIPT_PATH=`dirname $SCRIPT`
ARCH_FOLDER="$SCRIPT_PATH/arch"
SHARED_FOLDER="$SCRIPT_PATH/shared"

# Function to print styled log messages
log_step() {
    local message="$1"
    local bold_green='\033[1;32m'
    local reset='\033[0m'
    local separator="##########"

    # The entire line of separators and message will be bold green
    echo -e "\n${bold_green}${separator} ${message} ${separator}${reset}"
}

# Download wayland packages
log_step "Setting up wayland..."
yay -Sy --noconfirm hyprland waybar wofi xdg-desktop-portal-hyprland
yay -Sy --noconfirm qt5-wayland qt6-wayland # For Qt apps to run natively
yay -Sy --noconfrm swaylock-effects
log_step "Finished setting up wayland packages"

# Download core packages
log_step "Setting up core packages..."
yay -Sy --noconfirm kitty fish ripgrep
yay -Sy --noconfirm git neovim tmux
yay -Sy --noconfirm nerd-fonts-roboto-mono ttf-roboto-mono ttf-joypixels ttf-nerd-fonts-symbols
log_step "Finished setting up core packages"

# Check for NVIDIA GPU
if lspci | grep -iq 'nvidia'; then
    # Download NVIDIA driver
    log_step "Downloading NVDIA packages..."
    yay -Sy --noconfirm nvidia-dkms nvidia-utils egl-wayland libva-nvidia-driver
    log_step "Finished downloading NVIDIA package"
else
    log_step "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
fi

# Copy configs
log_step "Copying Configs..."
cd $SHARED_FOLDER
cp -R .config/ .gitconfig ~/
cd $ARCH_FOLDER
cp -R .config/ .xinitrc ~/
log_step "Finished Copying Configs"

# Copy fonts
mkdir -p ~/.local/share/fonts/
cp fonts/* ~/.local/share/fonts/
fc-cache -fv

# Copy wallpapers
mkdir -p ~/Pictures/wallpapers
cp wallpapers/* ~/Pictures/wallpapers

# Config terminal
chsh -s /usr/bin/fish

# Install starship
log_step "Installing starship..."
curl -sS https://starship.rs/install.sh | sh
log_step "Finished installing starship"

# Downloading utils packages
log_step "Downloading utils packages..."
sudo pacman -Sy yay
yay -Sy --noconfirm jump fzf fortune-mod cowsay btop mpv jq swww wdisplays wl-clipboard

# Download applications
log_step "Downloading applications..."
yay -Sy --noconfirm google-chrome zotero-bin spotify discord telegram-desktop-bin

# Setup nvim
log_step "Setting up nvim..."
yay -Sy --noconfirm nvim

# Fix bluetooth
log_step "Setting up bluetooth..."
yay -Sy --noconfirm bluez bluez-utils alsa-utils
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Fix wifi
log_step "Setting up wifi..."
yay -Sy --noconfirm networkmanager
sudo systemctl enable --now NetworkManager

# Media/brightness control
log_step "Setting up media/brightness control..."
yay -Sy --noconfirm playerctl brightnessctl

# C++
log_step "Setting up C++ environment..."
yay -Sy --noconfirm cmake gdb cppcheck clang

# Verilog
log_step "Setting up verilog..."
yay -Sy --noconfirm verible-bin

# Embedded
log_step "Setting up embedded environment..."
yay -Sy --noconfirm gcc-arm-none-eabi-bin arm-none-eabi-gdb stlink

# Latex
log_step "Setting up latex..."
yay -Sy --noconfirm pdfpc
#yay -Sy texlive-full <- Takes a long time

# Finished
log_step "Done with setting up environment"

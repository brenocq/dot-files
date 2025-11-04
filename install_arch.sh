#!/bin/bash

# Get the directory of the currently executing script
SCRIPT_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$SCRIPT_PATH" || exit

# Function to print styled log messages
log_step() {
    local message="$1"
    local bold_green='\033[1;32m'
    local reset='\033[0m'
    local separator="##########"
    echo -e "\n${bold_green}${separator} ${message} ${separator}${reset}"
}

# --- 1. Install Core Dependencies ---
log_step "Installing core dependencies (git, stow)..."
sudo pacman -Syu --noconfirm --needed git stow

# --- 2. Install Yay (AUR Helper) ---
if ! command -v yay &> /dev/null; then
    log_step "yay not found. Installing..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    log_step "yay is already installed."
fi

# --- 3. Install Packages from Lists ---
log_step "Installing all packages from lists with yay..."
yay -S --noconfirm --needed - < "$SCRIPT_PATH/arch_pkglist.txt"

# --- 4. Install Starship ---
if ! command -v starship &> /dev/null; then
    log_step "Installing starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    log_step "Starship is already installed."
fi

# --- 5. Check for NVIDIA ---
if lspci | grep -iq 'nvidia'; then
    log_step "NVIDIA GPU detected. Installing drivers..."
    # If nvidia GPU is detected, install the NVIDIA drivers
    yay -S --noconfirm --needed nvidia-dkms nvidia-utils egl-wayland libva-nvidia-driver
else
    log_step "No NVIDIA GPU detected. Skipping NVIDIA drivers."
fi

# --- 6. Set fish as default shell ---
if [ "$SHELL" != "/usr/bin/fish" ]; then
    log_step "Setting fish as default shell..."
    chsh -s /usr/bin/fish
else
    log_step "Fish is already the default shell."
fi

# --- 7. Stow (Symlink) Configs ---
log_step "Symlinking config files with stow..."
# Make sure we are in the dotfiles directory
cd "$SCRIPT_PATH" || exit

# Stow all shared configs and all arch-specific configs
# -R = Re-stow (deletes old symlinks and creates new ones)
# -t ~ = Target the home directory
stow -R -t ~ shared
stow -R -t ~ arch

# --- 8. Reload Font Cache ---
log_step "Reloading font cache..."
fc-cache -fv

# --- 9. Enable System Services ---
log_step "Enabling systemd services..."
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager

log_step "Done! Please log out and log back in for all changes to take effect."

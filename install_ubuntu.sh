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

# --- 1. Update Apt and Install Core Dependencies ---
log_step "Updating package lists and installing core dependencies..."
sudo apt-get update
sudo apt-get install -y git stow build-essential curl

# --- 2. Install Packages from List ---
log_step "Installing all packages from ubuntu_pkglist.txt..."
# We filter out comments (#) and empty lines
grep -vE "^\s*#|^\s*$" "$SCRIPT_PATH/ubuntu_pkglist.txt" | sudo xargs apt-get install -y

# --- 3. Install Starship ---
if ! command -v starship &> /dev/null; then
    log_step "Installing starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    log_step "Starship is already installed."
fi

# --- 4. Set fish as default shell ---
if [ "$SHELL" != "/usr/bin/fish" ]; then
    log_step "Setting fish as default shell..."
    if ! grep -Fxq "/usr/bin/fish" /etc/shells; then
        log_step "Adding /usr/bin/fish to /etc/shells"
        echo "/usr/bin/fish" | sudo tee -a /etc/shells
    fi
    chsh -s /usr/bin/fish
else
    log_step "Fish is already the default shell."
fi

# --- 5. Stow (Symlink) Configs ---
log_step "Symlinking config files with stow..."
# Make sure we are in the dotfiles directory
cd "$SCRIPT_PATH" || exit

# Stow all shared configs.
# Note: No "ubuntu" folder for stow yet, so we only stow "shared".
# -R = Re-stow (deletes old symlinks and creates new ones)
# -t ~ = Target the home directory
stow -R -t ~ shared

# --- 6. Reload Font Cache ---
log_step "Reloading font cache..."
fc-cache -fv

# --- 7. Enable System Services ---
log_step "Enabling systemd services..."
sudo systemctl enable --now bluetooth
sudo systemctl enable --now NetworkManager

log_step "Done! Please log out and log back in for all changes to take effect."

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

# --- 1. Install Homebrew ---
if ! command -v brew &> /dev/null; then
    log_step "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to path for this script's session (for Apple Silicon)
    if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    log_step "Homebrew is already installed."
fi

# --- 2. Install Packages from Brewfile ---
log_step "Updating Homebrew and installing packages from Brewfile..."
# Install all packages listed in the Brewfile
brew bundle install --file="$SCRIPT_PATH/Brewfile"

# --- 3. Set fish as default shell (if not already) ---
if [ -x "/opt/homebrew/bin/fish" ]; then
  fish_path="/opt/homebrew/bin/fish" # Apple Silicon
else
  fish_path="/usr/local/bin/fish" # Intel
fi

if [ "$SHELL" != "$fish_path" ]; then
    log_step "Setting $fish_path as default shell..."
    if ! grep -Fxq "$fish_path" /etc/shells; then
        log_step "Adding $fish_path to /etc/shells"
        echo "$fish_path" | sudo tee -a /etc/shells
    fi
    chsh -s "$fish_path"
else
    log_step "fish is already the default shell."
fi

# --- 4. Stow (Symlink) Configs ---
log_step "Symlinking config files with stow..."
# Make sure we are in the dotfiles directory
cd "$SCRIPT_PATH" || exit

# Stow all shared configs and all macos-specific configs
# -R = Re-stow (deletes old symlinks and creates new ones)
# -t ~ = Target the home directory
stow -R -t ~ shared
stow -R -t ~ macos

log_step "Done! Please restart your terminal for all changes to take effect."

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

# --- 5. Screenshot Shortcuts ---
log_step "Setting screenshot keyboard shortcuts..."
# Symbolic hotkey parameters are (character, key code, modifiers); 1048576 = Cmd.
# Written as XML so `enabled` is a boolean like System Settings stores it.
# These override the same Cmd shortcuts inside apps (save, find next).
set_hotkey() {
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
      "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>$2</integer><integer>$3</integer><integer>$4</integer></array></dict></dict>"
}
set_hotkey 31 115 1 1048576  # Selected area -> clipboard: Cmd+S (default Ctrl+Cmd+Shift+4)
set_hotkey 184 103 5 1048576 # Screenshot and recording options: Cmd+G (default Cmd+Shift+5)
set_hotkey 64 100 2 1048576  # Spotlight: Cmd+D like the Hyprland launcher (default Cmd+Space)
# The remaining capture shortcuts sit on Cmd+Shift+<digit>, which AeroSpace
# uses to move a window to that workspace; Cmd+G reaches the same captures.
disable_hotkey() {
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$1" \
      "<dict><key>enabled</key><false/></dict>"
}
disable_hotkey 30  # Selected area -> file (Cmd+Shift+4); Cmd+A stays Select All
disable_hotkey 28  # Whole screen -> file (Cmd+Shift+3)
disable_hotkey 29  # Whole screen -> clipboard (Ctrl+Cmd+Shift+3)
disable_hotkey 181 # Touch Bar -> file (Cmd+Shift+6)
disable_hotkey 182 # Touch Bar -> clipboard (Ctrl+Cmd+Shift+6)
# Apply without logging out
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# --- 6. Desktop settings for AeroSpace ---
log_step "Configuring the desktop for AeroSpace..."
# Stage Manager shrinks windows into a side strip underneath the tiling.
defaults write com.apple.WindowManager GloballyEnabled -bool false
# No icons on the desktop; the files stay in ~/Desktop.
defaults write com.apple.finder CreateDesktop -bool false
killall Finder
# The first launch asks for Accessibility access; the config starts it at
# login from then on. Native fullscreen (green button) and desktop widgets
# both confuse the tiling, so leave them alone and use alt-f instead.
open -a AeroSpace

log_step "Done! Grant AeroSpace Accessibility access when prompted, and restart your terminal."

# Dotfiles

Personal configuration files for Linux (Arch), macOS, and Ubuntu development environments.

## Overview

This repository contains my carefully curated dotfiles, optimized for a modern development workflow across multiple operating systems. The configurations are organized using [GNU Stow](https://www.gnu.org/software/stow/) for easy symlink management.

## Structure

```
.
├── arch/           # Arch Linux specific configs
├── macos/          # macOS specific configs
├── shared/         # Cross-platform configs
├── keyboard/       # Keyboard layouts (QMK)
├── install_arch.sh     # Arch Linux installer
├── install_macos.sh    # macOS installer
├── install_ubuntu.sh   # Ubuntu installer
├── arch_pkglist.txt    # Arch package list
├── ubuntu_pkglist.txt  # Ubuntu package list
└── Brewfile            # macOS package list
```

## Features

### Arch Linux (Hyprland Wayland Setup)
- **Window Manager:** Hyprland with custom keybindings
- **Status Bar:** Waybar with custom modules (CPU, memory, disk, network, brightness)
- **Terminal:** Kitty with Fish shell
- **Editor:** Neovim with extensive plugin configuration
- **Application Launcher:** Wofi
- **Notifications:** Mako
- **Screen Lock:** Hyprlock
- **File Manager:** Yazi (terminal) + Nautilus (GUI)
- **Theme:** Gruvbox Material color scheme
- **Wallpaper:** Hyprpaper with custom wallpapers

### macOS
- **Terminal:** Kitty with Zsh shell
- **Editor:** Neovim (shared config)
- **Shell Prompt:** Starship

### Shared
- **Editor:** Neovim with:
  - LSP support
  - Lazy.nvim plugin manager
  - Code completion (nvim-cmp)
  - File navigation (Telescope, Neo-tree)
  - Git integration
  - AI assistance (CodeCompanion)
- **Terminal:** Kitty with Gruvbox theme
- **Shell Prompt:** Starship
- **Multiplexer:** Tmux with vim-tmux-navigator
- **Git:** Custom configuration

## Quick Start

### Arch Linux

```bash
git clone https://github.com/yourusername/dot-files.git ~/dot-files
cd ~/dot-files
chmod +x install_arch.sh
./install_arch.sh
```

The script will:
1. Install core dependencies (git, stow)
2. Install yay AUR helper
3. Install all packages from `arch_pkglist.txt`
4. Install Starship prompt
5. Detect and install NVIDIA drivers if needed
6. Set Fish as the default shell
7. Symlink configs using GNU Stow
8. Reload font cache
9. Enable system services (Bluetooth, NetworkManager, Docker, etc.)

**Post-install:** Log out and back in for all changes to take effect.

### macOS

```bash
git clone https://github.com/yourusername/dot-files.git ~/dot-files
cd ~/dot-files
chmod +x install_macos.sh
./install_macos.sh
```

The script will:
1. Install Homebrew if not present
2. Install packages from Brewfile
3. Set Zsh as default shell
4. Symlink configs using GNU Stow

### Ubuntu

```bash
git clone https://github.com/yourusername/dot-files.git ~/dot-files
cd ~/dot-files
chmod +x install_ubuntu.sh
./install_ubuntu.sh
```

## What's Included

### Arch Linux Packages
- **Desktop:** Hyprland, Waybar, Wofi, Mako, Hyprlock, Hyprpaper
- **Terminal:** Kitty, Fish, Tmux, Neovim
- **Fonts:** Roboto Mono Nerd Font, JoyPixels
- **Utils:** Yazi, btop, fzf, ripgrep, neofetch, docker
- **Apps:** Zotero, Spotify, Discord, Telegram, Zen Browser
- **Dev Tools:** GCC ARM, STLink, GDB, Clang, CMake, Verible

### Hyprland Keybindings (Highlights)
- `SUPER + Q` - Close window
- `SUPER + Return` - Terminal
- `SUPER + E` - File manager
- `SUPER + D` - App launcher
- `SUPER + Escape` - Lock screen
- `SUPER + S` - Screenshot
- `SUPER + G` - Screen recording
- `SUPER + [1-9]` - Switch workspace
- `SUPER + Mouse` - Move/resize windows

### Waybar Modules
- Workspaces
- CPU usage
- Memory usage
- Disk usage (with tooltip)
- Network (up/down bandwidth)
- Audio (with pavucontrol)
- **Brightness** (controls both laptop and external monitors via DDC/CI)
- Battery
- Language indicator
- Clock

### Custom Scripts
- `waybar/scripts/brightness-control.sh` - Controls brightness for both laptop display and external monitors using brightnessctl + ddcutil
- `hypr/scripts/wallpaper.sh` - Wallpaper management

## External Monitor Brightness Control

The brightness module in Waybar now supports both laptop displays and external monitors via DDC/CI:
- Laptop display controlled via kernel backlight interface
- External monitors controlled via DDC/CI using `ddcutil`
- Both adjust simultaneously when scrolling on the brightness module

**Requirements:**
- `ddcutil` package
- `i2c-dev` kernel module loaded
- User in `i2c` group

This is automatically configured by the Arch installation script.

## Neovim Configuration

Located in `shared/.config/nvim/`, featuring:
- **Plugin Manager:** lazy.nvim
- **LSP:** Native LSP with nvim-lspconfig
- **Completion:** nvim-cmp with multiple sources
- **Fuzzy Finder:** Telescope
- **File Tree:** Neo-tree
- **Git:** Fugitive + Gitsigns
- **Navigation:** Harpoon + Leap
- **AI:** CodeCompanion for AI-assisted coding
- **Theme:** Gruvbox Material

Leader key is set to `Space`.

## Customization

### Modifying Package Lists
- **Arch:** Edit `arch_pkglist.txt`
- **macOS:** Edit `Brewfile`
- **Ubuntu:** Edit `ubuntu_pkglist.txt`

### Adding New Configs
1. Place OS-specific configs in `arch/`, `macos/`, or `ubuntu/`
2. Place cross-platform configs in `shared/`
3. Run `stow -R -t ~ shared` and/or `stow -R -t ~ arch` from the dotfiles directory

### Hyprland
Edit `arch/.config/hypr/hyprland.conf` for:
- Keybindings
- Window rules
- Animations
- Display settings

Monitor-specific settings are in `monitors.conf` and workspace settings in `workspaces.conf`.

## Dependencies

### Arch Linux
All dependencies are listed in `arch_pkglist.txt` and automatically installed by the setup script.

### macOS
All dependencies are listed in the `Brewfile` and automatically installed by the setup script.

## Notes

- Fonts are stored in `arch/.local/share/fonts/` and included in the repository
- Wallpapers are in `arch/Pictures/wallpapers/`
- The `.gitignore` excludes runtime files (fish variables, nvim lazy-lock, etc.)
- Keyboard layout for IDOBAO ID75 is available in `keyboard/`

## License

These dotfiles are provided as-is for personal use. Feel free to use, modify, and distribute as needed.

# .dotfiles

Arch + Hyprland config.

## How to setup

### Automated Installation (Recommended)

For a fresh Arch Linux installation, use the automated setup script:

```bash
# Download and run the installation script
curl -O https://raw.githubusercontent.com/seolcu/.dotfiles/main/.install.sh
chmod +x .install.sh
./.install.sh
```

This script will:
- Install yay (AUR helper)
- Install all required packages (Hyprland, Waybar, Kitty, etc.)
- Install Gruvbox GTK Theme
- Clone and setup dotfiles automatically
- Enable required system services

### Manual Installation

If you prefer to install manually or already have packages installed:

```bash
# Clone the repository
git clone --bare https://github.com/seolcu/.dotfiles $HOME/.dotfiles

# Add alias and source it (run both lines)
echo "alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
source ~/.bashrc

# Checkout your files (force overwrite if needed)
dot checkout -f

# Ignore untracked files
dot config --local status.showUntrackedFiles no
```

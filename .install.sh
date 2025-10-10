#!/bin/bash

set -e

echo "=== Arch Linux + Hyprland Setup Script ==="
echo "This script will install all required packages and set up your dotfiles"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please don't run this script as root"
   exit 1
fi

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR helper..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
fi

# Update system
echo "Updating system..."
yay -Syu --noconfirm

# Install base packages
echo "Installing base packages..."
sudo pacman -S --needed --noconfirm \
    base base-devel \
    linux linux-firmware \
    amd-ucode \
    efibootmgr \
    btrfs-progs \
    networkmanager \
    bluez bluez-utils blueberry

# Install Hyprland and Wayland ecosystem
echo "Installing Hyprland and Wayland packages..."
sudo pacman -S --needed --noconfirm \
    hyprland hyprpaper hypridle hyprlock hyprpolkitagent \
    xdg-desktop-portal-hyprland \
    waybar wofi swaync swayosd \
    qt5-wayland qt6-wayland \
    xorg-xwayland

# Install terminal and shell utilities
echo "Installing terminal and shell utilities..."
sudo pacman -S --needed --noconfirm \
    kitty \
    starship \
    neovim \
    git github-cli \
    htop fastfetch \
    tree \
    fd ripgrep \
    less unzip

# Install audio and media
echo "Installing audio and media packages..."
sudo pacman -S --needed --noconfirm \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack \
    wireplumber libpulse \
    gst-plugin-pipewire \
    pavucontrol \
    mpv imv

# Install GUI applications
echo "Installing GUI applications..."
sudo pacman -S --needed --noconfirm \
    nautilus \
    firefox-i18n-ko \
    evince \
    gnome-text-editor \
    gnome-keyring \
    obsidian \
    kdenlive

# Install utilities and tools
echo "Installing utilities and tools..."
sudo pacman -S --needed --noconfirm \
    wl-clipboard cliphist \
    grim slurp \
    brightnessctl \
    network-manager-applet \
    power-profiles-daemon \
    nwg-look \
    pandoc-cli \
    snapper \
    sof-firmware \
    ly \
    zram-generator \
    tailscale \
    proton-vpn-gtk-app

# Install fonts
echo "Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-liberation \
    noto-fonts noto-fonts-cjk noto-fonts-emoji

# Install theming packages
echo "Installing theming packages..."
sudo pacman -S --needed --noconfirm \
    gtk-engine-murrine \
    sassc

# Install gaming packages
echo "Installing gaming packages..."
sudo pacman -S --needed --noconfirm \
    steam \
    gamemode lib32-gamemode \
    gamescope

# Install AUR packages
echo "Installing AUR packages..."
yay -S --needed --noconfirm \
    kime-bin \
    yay-bin \
    localsend-bin \
    cbonsai \
    gamescope-session-steam-git \
    game-devices-udev \
    visual-studio-code-bin \
    slack-desktop \
    onlyoffice-bin \
    ente-auth-bin \
    opencode-bin \
    gemini-cli-bin

# Install Gruvbox GTK Theme
echo "Installing Gruvbox GTK Theme..."
cd /tmp
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
cd Gruvbox-GTK-Theme
./install.sh -t all -l
cd ~

# Clone dotfiles repository
echo "Setting up dotfiles..."
if [ -d "$HOME/.dotfiles" ]; then
    echo "Dotfiles directory already exists, skipping clone..."
else
    git clone --bare https://github.com/seolcu/.dotfiles $HOME/.dotfiles
fi

# Add alias temporarily
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Add alias to .bashrc if not present
if ! grep -q "alias dot=" ~/.bashrc 2>/dev/null; then
    echo "alias dot='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc
fi

# Backup existing files if they exist
mkdir -p ~/.config-backup
for file in .bashrc .config/hypr .config/waybar .config/kitty .config/kime .local/share/wallpapers; do
    if [ -e "$HOME/$file" ]; then
        echo "Backing up $file..."
        cp -r "$HOME/$file" ~/.config-backup/ 2>/dev/null || true
    fi
done

# Checkout dotfiles
echo "Checking out dotfiles..."
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout -f

# Configure dotfiles repo
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Source bashrc
source ~/.bashrc

# Configure ly display manager to use hidden log file
echo "Configuring ly display manager..."
sudo sed -i 's/^session_log = ly-session.log/session_log = .ly-session.log/' /etc/ly/config.ini

# Configure gaming optimizations
echo "Configuring gaming optimizations..."
sudo tee /etc/sysctl.d/80-gamecompatibility.conf > /dev/null <<EOF
vm.max_map_count = 2147483642
EOF

# Enable and start required services
echo "Enabling services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable NetworkManager bluetooth ly tailscaled

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "Next steps:"
echo "1. Reboot your system"
echo "2. Log in and select Hyprland as your session (via ly display manager)"
echo "3. Your dotfiles are now active!"
echo "4. The Gruvbox GTK theme has been installed for all color variants"
echo ""
echo "Note: Your old config files are backed up in ~/.config-backup/"
echo ""
echo "Additional manual steps you may want to do:"
echo "- Configure Tailscale: sudo tailscale up"
echo "- Configure Proton VPN"
echo "- Configure snapper for Btrfs snapshots"
echo "- Apply Gruvbox GTK theme using nwg-look or GNOME Tweaks"

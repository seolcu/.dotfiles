#!/bin/bash

set -euo pipefail

echo "=== Package Availability Validation ==="
echo ""

MISSING_PACMAN=()
MISSING_AUR=()

PACMAN_PACKAGES=(
    base base-devel
    linux linux-firmware
    amd-ucode
    efibootmgr
    btrfs-progs
    networkmanager
    bluez bluez-utils blueberry
    hyprland hyprpaper hypridle hyprlock hyprpolkitagent
    xdg-desktop-portal-hyprland
    waybar wofi swaync swayosd
    qt5-wayland qt6-wayland
    xorg-xwayland
    kitty
    starship
    neovim
    git github-cli
    htop fastfetch
    tree
    fd ripgrep
    less unzip
    man-db man-pages
    pipewire pipewire-alsa pipewire-pulse pipewire-jack
    wireplumber libpulse
    gst-plugin-pipewire
    pavucontrol
    mpv imv
    nautilus
    firefox-i18n-ko
    evince
    gnome-text-editor
    gnome-keyring
    obsidian
    kdenlive
    wl-clipboard cliphist
    grim slurp
    brightnessctl
    network-manager-applet
    power-profiles-daemon
    nwg-look
    pandoc-cli
    snapper
    sof-firmware
    ly
    zram-generator
    tailscale
    proton-vpn-gtk-app
    xdg-user-dirs
    xdg-user-dirs-gtk
    avahi
    nss-mdns
    fwupd
    ttf-jetbrains-mono-nerd
    ttf-liberation
    noto-fonts noto-fonts-cjk noto-fonts-emoji
    gtk-engine-murrine
    sassc
    steam
    gamemode lib32-gamemode
    gamescope
    qemu-full
    libvirt
    virt-manager
    virt-viewer
    dnsmasq
    iptables-nft
    dmidecode
)

AUR_PACKAGES=(
    kime-bin
    yay-bin
    localsend-bin
    cbonsai
    gamescope-session-steam-git
    game-devices-udev
    visual-studio-code-bin
    slack-desktop
    onlyoffice-bin
    ente-auth-bin
    opencode-bin
    gemini-cli-bin
)

echo "Checking official repository packages..."
for pkg in "${PACMAN_PACKAGES[@]}"; do
    if ! pacman -Si "$pkg" &>/dev/null; then
        MISSING_PACMAN+=("$pkg")
        echo "  [MISSING] $pkg"
    else
        echo "  [OK] $pkg"
    fi
done

echo ""
echo "Checking AUR packages..."
if ! command -v yay &>/dev/null; then
    echo "WARNING: yay not installed, skipping AUR package validation"
else
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! yay -Si "$pkg" &>/dev/null; then
            MISSING_AUR+=("$pkg")
            echo "  [MISSING] $pkg"
        else
            echo "  [OK] $pkg"
        fi
    done
fi

echo ""
echo "=== Validation Summary ==="
if [ ${#MISSING_PACMAN[@]} -eq 0 ] && [ ${#MISSING_AUR[@]} -eq 0 ]; then
    echo "✓ All packages are available!"
    exit 0
else
    echo "✗ Some packages are missing or unavailable:"
    if [ ${#MISSING_PACMAN[@]} -gt 0 ]; then
        echo ""
        echo "Official repository packages:"
        printf '  - %s\n' "${MISSING_PACMAN[@]}"
    fi
    if [ ${#MISSING_AUR[@]} -gt 0 ]; then
        echo ""
        echo "AUR packages:"
        printf '  - %s\n' "${MISSING_AUR[@]}"
    fi
    exit 1
fi

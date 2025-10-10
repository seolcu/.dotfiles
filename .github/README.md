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
- Install all required packages including:
  - **Desktop Environment**: Hyprland, Waybar, Wofi, SwayNC
  - **Terminal**: Kitty with Starship prompt
  - **Editor**: Neovim (with [custom config](https://github.com/seolcu/nvim))
  - **Audio**: PipeWire + WirePlumber
  - **Networking**: NetworkManager, Tailscale, Proton VPN, Avahi (mDNS)
  - **Bluetooth**: Bluez + Blueberry
  - **Gaming**: Steam, GameMode, Gamescope (with vm.max_map_count optimization)
  - **Virtualization**: QEMU/KVM, libvirt, virt-manager
  - **Utilities**: fwupd, snapper, and more
- Install Gruvbox GTK Theme
- Clone and setup dotfiles from this repository
- Clone neovim configuration from seolcu/nvim
- Configure services (ly display manager, libvirt, Avahi, etc.)
- Enable required system services

After installation, reboot and log in via ly display manager.

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

## Package List

See [.install.sh](.install.sh) for the complete list of installed packages.

## Post-Installation

After running the installation script:

1. **Reboot** your system
2. **Log in** via ly display manager and select Hyprland
3. **Configure Tailscale**: `sudo tailscale up`
4. **Configure Proton VPN** via GUI
5. **Apply GTK theme**: Use `nwg-look` to select Gruvbox theme
6. **Setup snapper** for Btrfs snapshots (if using Btrfs)
7. **Update firmware**: `fwupdmgr update`

## Troubleshooting

If the installation fails:
- Check which command failed (script exits on error)
- Run the failed command manually
- Resume from that point in the script

Old config files are backed up to `~/.config-backup/`

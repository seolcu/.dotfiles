# .dotfiles

Arch + Hyprland config.

## How to setup

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

#!/bin/bash

set -euo pipefail

echo "=== Package Availability Validation ==="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/.install.sh"

if [ ! -f "$INSTALL_SCRIPT" ]; then
    echo "ERROR: .install.sh not found at $INSTALL_SCRIPT"
    exit 1
fi

MISSING_PACMAN=()
MISSING_AUR=()

echo "Extracting packages from .install.sh..."

# Extract pacman packages
PACMAN_PACKAGES=$(grep -A 100 'sudo pacman -S --needed --noconfirm' "$INSTALL_SCRIPT" | \
    grep -v 'sudo pacman' | \
    grep -v '^#' | \
    grep -v 'echo' | \
    sed '/^$/d' | \
    sed 's/\\$//' | \
    tr -s ' ' '\n' | \
    grep -v '^$' | \
    sort -u)

# Extract AUR packages
AUR_PACKAGES=$(grep -A 100 'yay -S --needed --noconfirm' "$INSTALL_SCRIPT" | \
    grep -v 'yay -S' | \
    grep -v '^#' | \
    grep -v 'echo' | \
    sed '/^$/d' | \
    sed 's/\\$//' | \
    tr -s ' ' '\n' | \
    grep -v '^$' | \
    sort -u)

echo "Checking official repository packages..."
while IFS= read -r pkg; do
    if [ -n "$pkg" ]; then
        if ! pacman -Si "$pkg" &>/dev/null; then
            MISSING_PACMAN+=("$pkg")
            echo "  [MISSING] $pkg"
        else
            echo "  [OK] $pkg"
        fi
    fi
done <<< "$PACMAN_PACKAGES"

echo ""
echo "Checking AUR packages..."
if ! command -v yay &>/dev/null; then
    echo "WARNING: yay not installed, skipping AUR package validation"
else
    while IFS= read -r pkg; do
        if [ -n "$pkg" ]; then
            if ! yay -Si "$pkg" &>/dev/null; then
                MISSING_AUR+=("$pkg")
                echo "  [MISSING] $pkg"
            else
                echo "  [OK] $pkg"
            fi
        fi
    done <<< "$AUR_PACKAGES"
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

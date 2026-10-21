#!/usr/bin/env bash
set -e

echo "==> [1/4] Updating system databases..."
sudo pacman -Sy --noconfirm

# Standard Arch packages (via pacman)
NATIVE_PKGS=(
    git
    curl
    wget
    htop
    fastfetch
    vlc
    discord
    steam
)

# AUR packages (via yay)
AUR_PKGS=(
    zen-browser-bin
    visual-studio-code-bin
    spotify
)

echo "==> [2/4] Installing official repository packages..."
sudo pacman -S --needed --noconfirm "${NATIVE_PKGS[@]}"

echo "==> [3/4] Installing AUR packages via yay..."
# Check if yay exists; install if absent
if ! command -v yay &> /dev/null; then
    echo "yay not detected. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    (cd /tmp/yay-bin && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bin
fi

yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "==> [4/4] Applying custom shortcuts and configs..."
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Ensure Hyprland config directory exists
mkdir -p "$HOME/.config/hypr"

# Append custom keybind only if it doesn't already exist
if [ -f "$HYPR_CONFIG" ]; then
    grep -qxF 'bind = SUPER, B, exec, zen-browser' "$HYPR_CONFIG" || \
        echo 'bind = SUPER, B, exec, zen-browser' >> "$HYPR_CONFIG"
fi

echo "==> All tasks finished successfully! Restart your session."

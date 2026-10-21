#!/usr/bin/env bash
set -e

echo "==> [1/5] Updating repository database..."
sudo pacman -Sy --noconfirm

# Remove Omarchy's pre-bundled Discord web shortcut
echo "==> [2/5] Cleaning pre-bundled Discord web app..."
rm -f "$HOME/.local/share/applications/"*discord*.desktop 2>/dev/null || true

# Official Arch packages (via pacman)
PACMAN_PKGS=(
    discord
    telegram-desktop
    vlc
    proton-vpn-gtk-app
    wl-clipboard
    btop
)

echo "==> [3/5] Installing official repository packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# Ensure yay is present
if ! command -v yay &> /dev/null; then
    echo "==> Installing yay helper..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    (cd /tmp/yay-bin && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bin
fi

# AUR packages (via yay)
AUR_PKGS=(
    zen-browser-bin
    notesnook-bin
    stremio
    rustdesk-bin
    antigravity-ide
)

echo "==> [4/5] Installing AUR tools..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# Background services
echo "==> [5/5] Enabling background services..."
sudo systemctl enable --now bluetooth.service 2>/dev/null || true

echo "==> Setup completed successfully!"

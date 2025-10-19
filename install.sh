#!/bin/bash

set -e

# Update package lists and upgrade existing packages
sudo apt update
sudo apt upgrade -y

# Install core packages: i3, picom, chromium, alacritty, zsh, pywal, dunst, wget
sudo apt install -y i3 picom chromium alacritty zsh pywal dunst wget

# Install Neovim AppImage for latest version to avoid input bugs
NVIM_APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
wget -O nvim.appimage $NVIM_APPIMAGE_URL
chmod +x ./nvim.appimage
sudo mv ./nvim.appimage /usr/local/bin/nvim

# Set zsh as default shell for current user
chsh -s $(which zsh)

# Configure Alacritty TERM setting if not already set
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.yml"
mkdir -p "$(dirname "$ALACRITTY_CONFIG")"
if ! grep -q "^env:" "$ALACRITTY_CONFIG" 2>/dev/null; then
  echo -e "env:\n  TERM: xterm-256color" >> "$ALACRITTY_CONFIG"
elif ! grep -q "TERM:" "$ALACRITTY_CONFIG"; then
  echo "  TERM: xterm-256color" >> "$ALACRITTY_CONFIG"
fi

# Create minimal Neovim config to fix input timing issues
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"
cat > "$NVIM_CONFIG_DIR/init.vim" <<EOF
set timeoutlen=500
set ttimeoutlen=10
EOF

echo "Installation complete. Please log out and back in to start using zsh and run Alacritty with Neovim."


#!/bin/bash

set -e

# Update package lists and upgrade existing packages
sudo apt update
sudo apt upgrade -y

# Install core packages: i3, picom, chromium, alacritty, zsh, pywal, dunst, wget
sudo apt install -y picom zsh wget

# Web browser
sudo apt install -y chromium alacritty thunar

# Set zsh as default shell for current user
chsh -s $(which zsh)


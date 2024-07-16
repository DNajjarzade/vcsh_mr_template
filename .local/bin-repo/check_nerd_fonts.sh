#!/bin/bash

cat << EOF
 __________________________________________________________________________________________________________________
/ 8888888b.           888b    888                                             888  .d888                   888     \
| 888  "Y88b          8888b   888                                             888 d88P"                    888     |
| 888    888          88888b  888                                             888 888                      888     |
| 888    888  8888b.  888Y88b 888  8888b.      88888b.   .d88b.  888d888  .d88888 888888  .d88b.  88888b.  888888  |
| 888    888     "88b 888 Y88b888     "88b     888 "88b d8P  Y8b 888P"   d88" 888 888    d88""88b 888 "88b 888     |
| 888    888 .d888888 888  Y88888 .d888888     888  888 88888888 888     888  888 888    888  888 888  888 888     |
| 888  .d88P 888  888 888   Y8888 888  888     888  888 Y8b.     888     Y88b 888 888    Y88..88P 888  888 Y88b.   |
| 8888888P"  "Y888888 888    Y888 "Y888888     888  888  "Y8888  888      "Y88888 888     "Y88P"  888  888  "Y888  |
|                                                                                                                  |
|                                                                                                                  |
|                                                                                                                  |
| d8b                   888             888 888                                                                    |
| Y8P                   888             888 888                                                                    |
|                       888             888 888                                                                    |
| 888 88888b.  .d8888b  888888  8888b.  888 888  .d88b.  888d888                                                   |
| 888 888 "88b 88K      888        "88b 888 888 d8P  Y8b 888P"                                                     |
| 888 888  888 "Y8888b. 888    .d888888 888 888 88888888 888                                                       |
| 888 888  888      X88 Y88b.  888  888 888 888 Y8b.     888                                                       |
| 888 888  888  88888P'  "Y888 "Y888888 888 888  "Y8888  888                                                       |
|                                                                                                                  |
|                                                                                                                  |
\                                                                                                                  /
 ------------------------------------------------------------------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
EOF
# ============================================================================
# Script Name: check_nerd_fonts.sh
# Description: Check and Installs some common Nerd Fonts 
# Author: dariush najjarzade
# Creation Date: 2024-07-16
# Last Modified: 2024-07-16
#
# Usage: ./install_asdf_packages.sh <package1> <package2> ...
# Example: ./install_asdf_packages.sh python nodejs rust go kubectl
#
# This script will check for Nerd Fonts, offer to install missing ones, and handle the download and installation process.
# It installs fonts in the user's local font directory, which doesn't require root privileges. 
#
# Requirements:
#  - This script assumes that wget and unzip are installed on the system. 
#    If they're not, you might need to install them first or replace wget with curl if that's available.
# - Internet connection to fetch ASDF plugins and packages
#
# Note: Some packages may require additional system dependencies
# ============================================================================
#
#
# Array of common Nerd Font names and their download URLs
set -e
declare -A nerd_fonts=(
    ["0xProto"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.zip"
    ["3270"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/3270.zip"
    ["Agave"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Agave.zip"
    ["AnonymousPro"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/AnonymousPro.zip"
    ["Arimo"]="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Arimo.zip"
)

# Function to check if a font is installed
check_font() {
    fc-list | grep -i "$1" | grep -i "nerd" > /dev/null
    return $?
}

# Function to install a font
install_font() {
    local font_name=$1
    local download_url=${nerd_fonts[$font_name]}
    local temp_dir=$(mktemp -d)
    local font_dir="$HOME/.local/share/fonts"

    echo "Downloading $font_name Nerd Font..."
    if ! wget -q "$download_url" -O "$temp_dir/$font_name.zip"; then
        echo "Failed to download $font_name Nerd Font."
        return 1
    fi

    echo "Installing $font_name Nerd Font..."
    mkdir -p "$font_dir"
    unzip -q "$temp_dir/$font_name.zip" -d "$font_dir"

    rm -rf "$temp_dir"

    echo "Updating font cache..."
    fc-cache -fv "$font_dir"

    echo "$font_name Nerd Font has been installed successfully."
}

echo "Checking for installed Nerd Fonts..."
echo

for font_name in "${!nerd_fonts[@]}"; do
    if check_font "$font_name"; then
        echo "✅ $font_name Nerd Font is installed"
    else
        echo "❌ $font_name Nerd Font is not installed"
        read -p "Do you want to install $font_name Nerd Font? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_font "$font_name"
        fi
    fi
done

echo
echo "Font check and installation process completed."

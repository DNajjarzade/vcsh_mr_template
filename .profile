#!/bin/bash

#  _________________________________________________________________________________________
# / 8888888b.         888b    888                                      .d888d8b888          \
# | 888  "Y88b        8888b   888                                     d88P" Y8P888          |
# | 888    888        88888b  888                                     888      888          |
# | 888    888 8888b. 888Y88b 888 8888b.       88888b. 888d888 .d88b. 888888888888 .d88b.   |
# | 888    888    "88b888 Y88b888    "88b      888 "88b888P"  d88""88b888   888888d8P  Y8b  |
# | 888    888.d888888888  Y88888.d888888      888  888888    888  888888   88888888888888  |
# | 888  .d88P888  888888   Y8888888  888   d8b888 d88P888    Y88..88P888   888888Y8b.      |
# | 8888888P" "Y888888888    Y888"Y888888   Y8P88888P" 888     "Y88P" 888   888888 "Y8888   |
# |                                            888                                          |
# |                                            888                                          |
# \                                            888                                          /
#  -----------------------------------------------------------------------------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||
# 
# .profile - Bashrc Profile Configuration File
# Description: Configuration and customization for login shells.
# Author: dariush najjarzade
# created: 2024-07-14
# Last Modified: Thu Aug 15 11:46:50 PM +0330 2024
#
# Function to add directories to PATH if they exist
add_to_path() {
    [ -d "$1" ] && PATH="$1:$PATH"
}

# Add user's private bin to PATH
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/emacs/bin"
add_to_path "$HOME/.SpaceVim/bin"

files_to_source=(
    "$HOME/.bash_aliases"
    "$HOME/.bash_functions"
    "$HOME/.bash_completions/*"
)

for file in "${files_to_source[@]}"; do
    [ -f "$file" ] && source "$file"
done

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
add_to_path "$PYENV_ROOT/bin"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# Ruby version manager (rbenv) setup
add_to_path "$HOME/.rbenv/bin"
command -v rbenv >/dev/null && eval "$(rbenv init -)"

# Krew (Kubernetes plugin manager) setup
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Homebrew setup
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Nix installation path
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

# Add various directories to PATH
[ -f "$HOME/.config/emacs/bin" ] && add_to_path "$HOME/.config/emacs/bin"
[ -f /usr/local/go/bin ] && add_to_path "/usr/local/go/bin"
[ -f /nix/var/nix/profiles/default/bin ] && add_to_path "/nix/var/nix/profiles/default/bin"

# Display fancy MOTD (Message of the Day) if not already shown
if [ -z "$FANCY_MOTD" ]; then
    ~/fancy-motd/motd.sh
    export FANCY_MOTD=1
fi

# Set locale
# export LC_ALL=C
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Source .bashrc if it exists
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
# [ -f "$HOME/.local/bin-repo/wallpaper_rotate.sh" ] && ~/.local/bin-repo/wallpaper_rotate.sh

if [ -f "~/.nvm" ]; then
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Apply custom key mappings
[ -f ~/xmodemap ] && xmodmap ~/xmodemap

# Load environment variables from .env file
load_env


#
# starship update status icons
#
PACKAGE_INFO_FILE="$HOME/.config/starship/package_updates.txt"

# Read from the package info file if it exists
if [ -f "$PACKAGE_INFO_FILE" ]; then
  while read -r line; do
    export "$line"
  done < "$PACKAGE_INFO_FILE"
fi

# Combine all update variables into a single variable
SOFTWARE_UPDATE_AVAILABLE=""
for update in "$APT_UPDATE" "$BREW_UPDATE" "$PIP_UPDATE" "$FLATPAK_UPDATE"; do
  if [ -n "$update" ]; then
    SOFTWARE_UPDATE_AVAILABLE+="$update "
  fi
done

# Export the combined variable
export SOFTWARE_UPDATE_AVAILABLE



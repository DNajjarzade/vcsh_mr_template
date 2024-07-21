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
# Last Modified: 2024-07-14
#
# Function to add directories to PATH if they exist
add_to_path() {
    [ -d "$1" ] && PATH="$1:$PATH"
}

# Add user's private bin to PATH
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/emacs/bin"

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
add_to_path "$PYENV_ROOT/bin"
command -v pyenv >/dev/null && eval "$(pyenv init -)"

# Ruby version manager (rbenv) setup
add_to_path "$HOME/.rbenv/bin"
command -v rbenv >/dev/null && eval "$(rbenv init -)"

# Krew (Kubernetes plugin manager) setup
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Apply custom key mappings
[ -f ~/xmodemap ] && xmodmap ~/xmodemap

# Homebrew setup
[ -f /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Nix installation path
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

# Add various directories to PATH
[ -f "$HOME/.config/emacs/bin" ] && add_to_path "$HOME/.config/emacs/bin"
[ -f /usr/local/go/bin ] && add_to_path "/usr/local/go/bin"
[ -f /nix/var/nix/profiles/default/bin ] && add_to_path "/nix/var/nix/profiles/default/bin"

# Proxy settings
# export HTTP_PROXY="http://192.168.1.12:8081"
# export HTTPS_PROXY="http://192.168.1.12:8081"
# export NO_PROXY="*.najarza.de,git.najjarza.de,${no_proxy},$(echo 192.168.1.{1..255} | sed 's/ /,/g')"
# export no_proxy="*.najarza.de,git.najjarza.de,$(echo 192.168.1.{1..10} | sed 's/ /,/g'),$(echo 10.0.0.{20..30} | sed 's/ /,/g'),$(echo 172.16.0.{30..40} | sed 's/ /,/g')"
# export NO_PROXY=${no_proxy}

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

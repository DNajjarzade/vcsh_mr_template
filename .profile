#!/bin/bash

#                     __ _ _      
#    _ __  _ __ ___  / _(_) | ___ 
#   | '_ \| '__/ _ \| |_| | |/ _ \
#  _| |_) | | | (_) |  _| | |  __/
# (_) .__/|_|  \___/|_| |_|_|\___|
#   |_|                           
# 
# .profile - User's Profile Configuration File
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
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Nix installation path
export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.share:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

# Add various directories to PATH
[ -f "$HOME/.config/emacs/bin" ] && add_to_path "$HOME/.config/emacs/bin"
[ -f /usr/local/go/bin ] && add_to_path "/usr/local/go/bin"
[ -f /nix/var/nix/profiles/default/bin ] && add_to_path "/nix/var/nix/profiles/default/bin"

# Proxy settings
export HTTP_PROXY="http://192.168.1.12:8081"
export HTTPS_PROXY="http://192.168.1.12:8081"
# export NO_PROXY="*.najarza.de,git.najjarza.de,${no_proxy},$(echo 192.168.1.{1..255} | sed 's/ /,/g')"
export no_proxy="*.najarza.de,git.najjarza.de,$(echo 192.168.1.{1..10} | sed 's/ /,/g'),$(echo 10.0.0.{20..30} | sed 's/ /,/g'),$(echo 172.16.0.{30..40} | sed 's/ /,/g')"
export NO_PROXY=${no_proxy}

# Display fancy MOTD (Message of the Day) if not already shown
if [ -z "$FANCY_MOTD" ]; then
    ~/fancy-motd/motd.sh
    export FANCY_MOTD=1
fi

# Set locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Source .bashrc if it exists
[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

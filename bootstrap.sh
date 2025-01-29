#!/bin/bash

cat << 'EOF'
______________________________________________________________________________________________
/ 888                     888           888                              .d888                 \
| 888                     888           888                             d88P"                  |
| 888                     888           888                             888                    |
| 88888b.  .d88b.  .d88b. 888888.d8888b 888888888d888 8888b. 88888b.    888888 .d88b. 888d888  |
| 888 "88bd88""88bd88""88b888   88K     888   888P"      "88b888 "88b   888   d88""88b888P"    |
| 888  888888  888888  888888   "Y8888b.888   888    .d888888888  888   888   888  888888      |
| 888 d88PY88..88PY88..88PY88b.      X88Y88b. 888    888  888888 d88P   888   Y88..88P888      |
| 88888P"  "Y88P"  "Y88P"  "Y888 88888P" "Y888888    "Y88888888888P"    888    "Y88P" 888      |
|                                                            888                               |
|                                                            888                               |
|                                                            888                               |
| 8888888b.         888b    888                                   .d888d8b888                  |
| 888  "Y88b        8888b   888                                  d88P" Y8P888                  |
| 888    888        88888b  888                                  888      888                  |
| 888    888 8888b. 888Y88b 888 8888b.    88888b. 888d888 .d88b. 888888888888 .d88b.           |
| 888    888    "88b888 Y88b888    "88b   888 "88b888P"  d88""88b888   888888d8P  Y8b          |
| 888    888.d888888888  Y88888.d888888   888  888888    888  888888   88888888888888          |
| 888  .d88P888  888888   Y8888888  888   888 d88P888    Y88..88P888   888888Y8b.              |
| 8888888P" "Y888888888    Y888"Y888888   88888P" 888     "Y88P" 888   888888 "Y8888           |
|                                         888                                                  |
|                                         888                                                  |
\                                         888                                                  /
 ----------------------------------------------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
     #  curl -L https://pb.najjarza.de/setup | bash
       
     #  long url command:
       
     #  curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash

     #  Usage: sudo ./setup_vcsh_mr.sh [-h] [-v] [repository_url]
     #  -h  Display this help message
     #  -v  Verbose mode
     #  -y  Automatic yes to prompts
     #  repository_url  Optional: Specify a custom repository URL
EOF

##############################################################################
# Script Name: bootstrap.sh
# Description: This script sets up VCSH and MR for managing dotfiles with
#              improved error handling, logging, and flexibility
# Author: dariush najjarzde
# Usage: sudo ./setup_vcsh_mr.sh [-h] [-v] [repository_url]
# Creation Date: 2024-07-15
# Last Modified: 2024-07-15
##############################################################################

set -euo pipefail
trap 'echo "Error: Script failed at line $LINENO. Check logs for details."; exit 1' ERR

# Set locale
export LC_ALL=C.UTF-8
export LANG=en_US.UTF-8

# Variables
USER=$(whoami)
REPO_URL="https://github.com/DNajjarzade/vcsh_mr_template.git"
BRANCH_NAME="mr"
LOG_FILE="$HOME/vcsh_mr_setup.log"  # Changed to user-specific log file
VERBOSE=false
AUTO_YES=false

# Function to display help message
show_help() {
    echo "Usage: $0 [-h] [-v] [-y] [repository_url]"
    echo "  -h  Display this help message"
    echo "  -v  Verbose mode"
    echo "  -y  Automatic yes to prompts"
    echo "  repository_url  Optional: Specify a custom repository URL"
}

# Parse command-line options
while getopts ":hvyY" opt; do
    case ${opt} in
        h ) show_help; exit 0 ;;
        v ) VERBOSE=true; set -x ;;
        y|Y ) AUTO_YES=true ;;
        \? ) echo "Invalid Option: -$OPTARG" 1>&2; show_help; exit 1 ;;
    esac
done
shift $((OPTIND -1))

# Setup logging
exec > >(tee -a "$LOG_FILE") 2>&1
echo "Starting setup at $(date)"

# Use custom repository URL if provided
if [ $# -eq 1 ]; then
    REPO_URL=$1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run a command with sudo if available and necessary
run_with_sudo() {
    if command_exists sudo; then
        sudo "$@"
    else
        "$@"
    fi
}

# Function to backup and remove existing files
backup_and_remove() {
    local file=$1
    if [ -f "$HOME/$file" ]; then
        echo "Backing up and removing existing $file..."
        mv "$HOME/$file" "$HOME/${file}.bak"
        echo "Existing $file backed up to ${file}.bak and removed."
    else
        echo "$file does not exist. No action needed."
    fi
}

# Backup and remove .bashrc and .profile
backup_and_remove ".bashrc"
backup_and_remove ".profile"

# List of required packages
REQUIRED_PACKAGES=(
    vcsh
    ansible
    curl
    git
    git-crypt
    gpg
    gpg-agent
    lolcat
    neofetch
    mc
    myrepos
    wget
    vim
    tmux
)

# Function to check if a package is installed
is_package_installed() {
    if command_exists "$1"; then
        return 0  # Package is installed
    else
        return 1  # Package is not installed
    fi
}

# Function to install missing packages
install_missing_packages() {
    local missing_packages=()

    # Check which packages are missing
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! is_package_installed "$pkg"; then
            missing_packages+=("$pkg")
        fi
    done

    # If there are missing packages, install them
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo "The following packages are missing and will be installed: ${missing_packages[*]}"
        install_package "${missing_packages[@]}"
    else
        echo "All required packages are already installed."
    fi
}

# Function to install packages based on the package manager
install_package() {
    local packages=("$@")
    local pkg_manager=""
    local install_cmd=""

    if command_exists apt-get; then
        pkg_manager="apt-get"
        install_cmd="apt-get install -y"
    elif command_exists dnf; then
        pkg_manager="dnf"
        install_cmd="dnf install -y"
    elif command_exists yum; then
        pkg_manager="yum"
        install_cmd="yum install -y"
    elif command_exists pacman; then
        pkg_manager="pacman"
        install_cmd="pacman -Sy --noconfirm"
    elif command_exists apk; then
        pkg_manager="apk"
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" | run_with_sudo tee -a /etc/apk/repositories
        install_cmd="apk add"
    elif command_exists zypper; then
        pkg_manager="zypper"
        install_cmd="zypper install -y"
    elif command_exists brew; then
        pkg_manager="brew"
        install_cmd="brew install"
    else
        echo "Unsupported package manager. Please install the following packages manually: ${packages[*]}"
        return 1
    fi

    # Update package manager (if applicable)
    if [[ "$pkg_manager" != "brew" ]]; then
        echo "Updating package manager ($pkg_manager)..."
        run_with_sudo $pkg_manager update || echo "Warning: Failed to update $pkg_manager. Continuing..."
    fi

    # Install packages
    for pkg in "${packages[@]}"; do
        echo "Installing $pkg using $pkg_manager..."
        if run_with_sudo $install_cmd "$pkg"; then
            echo "Successfully installed $pkg."
        else
            echo "Failed to install $pkg. Please install it manually."
        fi
    done
}

# Install required packages if they are not already installed
echo "Checking for missing packages..."
install_missing_packages

# Special handling for vcsh (if not installed via package manager)
if ! command_exists vcsh; then
    echo "Installing vcsh manually..."
    curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh -o ~/.local/bin/vcsh
    chmod +x ~/.local/bin/vcsh
fi

# Clone the repository using vcsh
echo "Cloning the home repository..."
vcsh clone -b "$BRANCH_NAME" "$REPO_URL" mr

# Initialize and update all repositories managed by mr
echo "Initializing and updating repositories..."
# Temporarily disable exit on error for mr update
set +e 
mr checkout
mr update >> "$LOG_FILE" 2>&1
if [ $? -ne 0 ]; then
    echo "Warning: 'mr update' encountered errors. Check $LOG_FILE for details."
fi
set -e  # Re-enable exit on error for the rest of the script

# Run update-binaries.sh if it exists
if [ -f ~/.local/bin-repo/update-binaries.sh ]; then
    echo "Running update-binaries.sh..."
    bash ~/.local/bin-repo/update-binaries.sh
    echo "update-binaries.sh completed."
else
    echo "update-binaries.sh not found, skipping."
fi

# Install starship
echo "Installing starship..."
curl -sS https://starship.rs/install.sh | sh

# Install ble.sh (required by atuin)
if ! command_exists ble.sh; then
    echo "Installing ble.sh..."
    curl -fsSL https://raw.githubusercontent.com/akinomyoga/ble.sh/master/install.sh | bash
    echo "ble.sh installed successfully."
else
    echo "ble.sh is already installed."
fi

# Install atuin
echo "Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
echo "atuin installed successfully."

# Ansible pull function
ansible_pull() {
    echo "Setting up locale and ansible-pull..."
    echo LC_ALL=C.UTF-8 | run_with_sudo tee /etc/default/locale
    echo LANG=en_US.UTF-8 | run_with_sudo tee -a /etc/default/locale
    echo LANGUAGE=en_US.UTF-8 | run_with_sudo tee -a /etc/default/locale
    run_with_sudo locale-gen en_US.UTF-8
    run_with_sudo export LC_ALL=C.UTF-8
    USER=$(whoami)
    echo "Current user is: $USER"
    export forcce=yes

    run_with_sudo ansible-pull --purge -o -C ansible -d /tmp/super_user_tasks/ -f -U "$REPO_URL" /tmp/super_user_tasks/Documents/projects/personal/ansible/superuser-play.yml
    ansible-pull --purge -o -C ansible -d /tmp/user_tasks/ -f -U "$REPO_URL" /tmp/user_tasks/Documents/projects/personal/ansible/user-play.yml
}
trap ansible_pull EXIT

echo "Script execution completed at $(date)"
source ~/.profile

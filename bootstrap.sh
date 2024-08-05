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
     #  curl https://pb.najjarza.de/~setup | bash
       
     #  create short url with:
       
     #  curl -F c=@- https://pb.najjarza.de/~setup <<< $(curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash)
       
     #  long url command:
       
     #  curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
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

# set -e
# trap 'echo "An error occurred. Exiting..."; exit 1' ERR

# Set locale
export LC_ALL=C.UTF-8
export LANG=en_US.UTF-8

# Default values
REPO_URL="https://github.com/DNajjarzade/vcsh_mr_template.git"
BRANCH_NAME="mr"
LOG_FILE="/var/log/vcsh_mr_setup.log"
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
        h )
            show_help
            exit 0
            ;;
        v )
            VERBOSE=true
            set -x
            ;;
        y|Y )
            AUTO_YES=true
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            show_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check for root privileges
# if [[ $EUID -ne 0 ]]; then
#    echo "This script must be run as root or with sudo privileges"
#    exit 1
# fi

# check for sudo
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run a command with sudo if available and necessary
run_with_sudo() {
    # if command_exists sudo && [ "$(id -u)" -ne 0 ]; then
    if command_exists sudo; then
        sudo "$@"
    else
        "$@"
    fi
}

# Setup logging
exec > >(run_with_sudo tee -a "$LOG_FILE") 2>&1
echo "Starting setup at $(date)"

# Use custom repository URL if provided
if [ $# -eq 1 ]; then
    REPO_URL=$1
fi

# Function to install packages based on the package manager
install_package() {
    # # Function to check if a command exists
    # command_exists() {
    #     command -v "$1" >/dev/null 2>&1
    # }

    # # Function to run a command with sudo if available and necessary
    # run_with_sudo() {
    #     if command_exists sudo && [ "$(id -u)" -ne 0 ]; then
    #         sudo "$@"
    #     else
    #         "$@"
    #     fi
    # }

    if command_exists apt-get; then
        run_with_sudo apt-get update
        run_with_sudo apt-get install -y "$@"
    elif command_exists dnf; then
        run_with_sudo dnf install -y "$@"
    elif command_exists yum; then
        run_with_sudo yum install -y "$@"
    elif command_exists pacman; then
        run_with_sudo pacman -Sy --noconfirm "$@"
    elif command_exists apk; then
        echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" | run_with_sudo tee -a /etc/apk/repositories
        run_with_sudo apk update
        run_with_sudo apk add "$@"
    else
        echo "Unsupported package manager. Please install $* manually."
        return 1
    fi
}


# Function to check vcsh version
check_vcsh_version() {
    local version=$(vcsh version | awk '{print $2}')
    if [[ $(echo "$version 1.20" | awk '{print ($1 < $2)}') -eq 1 ]]; then
        echo "vcsh version $version is too old. Please upgrade to 1.20 or newer."
        exit 1
    fi
}

# Function to show progress
show_progress() {
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Install required packages
if ! command_exists mr; then
    echo "Installing required packages..."
    install_package vcsh ansible curl git git-crypt gpg gpg-agent lolcat neofetch mc myrepos wget vim
    if ! command_exists vcsh; then
        echo "Installing vcsh ..."
        curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh -o ~/.local/bin/vcsh
        chmod +x ~/.local/bin/vcsh
    fi
fi


# check_vcsh_version
echo vcsh version $(vcsh version)

# Clone the repository using vcsh
echo "Cloning the home repository..."
vcsh clone -b "$BRANCH_NAME" "$REPO_URL" mr &
show_progress $!

vcsh mr checkout "$BRANCH_NAME"
# vcsh mr branch --track "$BRANCH_NAME" origin/"$BRANCH_NAME"

# Initialize and update all repositories managed by mr
echo "Initializing and updating repositories..."

# # Run mr update
# echo "Running mr update..."
# mr update &
# show_progress $!

# Run update-binaries.sh if it exists
if [ -f ~/.local/bin-repo/update-binaries.sh ]; then
    echo "Running update-binaries.sh..."
    bash ~/.local/bin-repo/update-binaries.sh &
    show_progress $!
    echo "update-binaries.sh completed."
else
    echo "update-binaries.sh not found, skipping."
fi

# Run mr update
echo "Running mr update..."
mr update &
show_progress $!

echo "Setup complete!"
# Ansible pull function
ansible_pull() {
    echo "Setting up locale and ansible-pull..."
    # Add any necessary ansible_pull tasks here
    echo LC_ALL=C.UTF-8 | run_with_sudo tee /etc/default/locale
    echo LANG=en_US.UTF-8 | run_with_sudo tee -a /etc/default/locale
    echo LANGUAGE=en_US.UTF-8 | run_with_sudo tee -a /etc/default/locale
    run_with_sudo locale-gen en_US.UTF-8
    run_with_sudo export LC_ALL=C.UTF-8 
    run_with_sudo ansible-pull -C ansible -U https://github.com/DNajjarzade/vcsh_mr_template.git 'Documents/projects/personal/ansible/local.yml'
}
trap ansible_pull EXIT

echo "Script execution completed at $(date)"
source ~/.profile

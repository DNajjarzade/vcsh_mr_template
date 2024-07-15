#!/bin/bash

##############################################################################
# Script Name: bootstrap.sh
# Description: This script sets up VCSH and MR for managing dotfiles with
#              improved error handling, logging, and flexibility
# Author: dariush najjarzde
# Usage: sudo ./setup_vcsh_mr.sh [-h] [-v] [repository_url]
# Creation Date: 2024-07-15
# Last Modified: 2024-07-15
##############################################################################

#!/bin/bash

echo '
            ____          _   _                          __ _ _      
           |  _ \  __ _  | \ | | __ _   _ __  _ __ ___  / _(_) | ___ 
           | | | |/ _` | |  \| |/ _` | |  _ \|  __/ _ \| |_| | |/ _ \
           | |_| | (_| |_| |\  | (_| | | |_) | | | (_) |  _| | |  __/
           |____/ \__,_(_)_| \_|\__,_| | .__/|_|  \___/|_| |_|_|\___|
                                       |_|                           
                 _                 _       _                   
                | |__   ___   ___ | |_ ___| |_ _ __ __ _ _ __  
                |  _ \ / _ \ / _ \| __/ __| __|  __/ _` |  _ \ 
                | |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
                |_.__/ \___/ \___/ \__|___/\__|_|  \__,_| .__/ 
                                                        |_|    
     #  curl https://pb.najjarza.de/~setup | bash
       
     #  create short url with:
       
     #  curl -F c=@- https://pb.najjarza.de/~setup <<< $(curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash)
       
     #  long url command:
       
     #  curl https://raw.githubusercontent.com/DNajjarzade/vcsh_mr_template/bootstrap/bootstrap.sh | bash
'

# set -e
# trap 'echo "An error occurred. Exiting..."; exit 1' ERR

# Set locale
export LC_ALL=C
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
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo privileges"
   exit 1
fi

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

# Function to install packages based on the package manager
install_package() {
    if command_exists apt-get; then
        apt-get update
        apt-get install -y "$@"
    elif command_exists dnf; then
        dnf install -y "$@"
    elif command_exists yum; then
        yum install -y "$@"
    elif command_exists pacman; then
        pacman -Sy --noconfirm "$@"
    elif command_exists apk; then
        apk update
        apk add "$@"        
    else
        echo "Unsupported package manager. Please install $@ manually."
        exit 1
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
if ! command_exists vcsh || ! command_exists mr; then
    echo "Installing required packages..."
    install_package myrepos mc vim git curl ansible gpg gpg-agent git-crypt
    
    if ! command_exists vcsh; then
        echo "Installing vcsh ..."
        curl -fsLS https://github.com/RichiH/vcsh/releases/latest/download/vcsh-standalone.sh -o /usr/local/bin/vcsh
        chmod +x /usr/local/bin/vcsh
    fi
fi

# Check vcsh version
# check_vcsh_version

# Clone the repository using vcsh
echo "Cloning the home repository..."
vcsh clone -b "$BRANCH_NAME" "$REPO_URL" mr &
show_progress $!

vcsh mr checkout "$BRANCH_NAME"
# vcsh mr branch --track "$BRANCH_NAME" origin/"$BRANCH_NAME"

# Initialize and update all repositories managed by mr
echo "Initializing and updating repositories..."

# Run mr update
echo "Running mr update..."
mr update &
show_progress $!

# Run update-binaries.sh if it exists
if [ -f ~/.local/bin-repo/update-binaries.sh ]; then
    if [ "$AUTO_YES" = true ]; then
        echo "Running update-binaries.sh..."
        bash ~/.local/bin-repo/update-binaries.sh &
        show_progress $!
        echo "update-binaries.sh completed."
    else
        read -p "Do you want to run update-binaries.sh? (y/n) " -n 1 -r
        echo    # Move to a new line
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Running update-binaries.sh..."
            bash ~/.local/bin-repo/update-binaries.sh &
            show_progress $!
            echo "update-binaries.sh completed."
        else
            echo "Skipping update-binaries.sh."
        fi
    fi
else
    echo "update-binaries.sh not found, skipping."
fi

# Run mr update
echo "Running mr update..."
mr update &
show_progress $!

echo "Setup complete!"
# Cleanup function
cleanup() {
    echo "Cleaning up..."
    # Add any necessary cleanup tasks here
}
trap cleanup EXIT

echo "Script execution completed at $(date)"

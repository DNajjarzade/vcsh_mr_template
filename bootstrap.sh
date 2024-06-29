#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages based on the package manager
install_package() {
    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y "$@"
    elif command_exists dnf; then
        sudo dnf install -y "$@"
    elif command_exists yum; then
        sudo yum install -y "$@"
    elif command_exists pacman; then
        sudo pacman -Sy --noconfirm "$@"
    else
        echo "Unsupported package manager. Please install $@ manually."
        exit 1
    fi
}

# Install vcsh and mr if not already installed
if ! command_exists vcsh || ! command_exists mr; then
    echo "Installing vcsh and mr..."
    install_package vcsh mr
fi

# Clone the repository using vcsh
echo "Cloning the home repository..."
vcsh clone https://github.com/DNajjarzade/vcsh_mr_template.git mr
vcsh mr checkout mr

# Initialize and update all repositories managed by mr
echo "Initializing and updating repositories..."
mr update

echo "Setup complete!"
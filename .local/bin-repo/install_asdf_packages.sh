#!/bin/bash

cat << EOF
 _________________________________________________________________________
/ 8888888b.         888b    888                                888 .d888  \
| 888  "Y88b        8888b   888                                888d88P"   |
| 888    888        88888b  888                                888888     |
| 888    888 8888b. 888Y88b 888 8888b.     8888b. .d8888b  .d88888888888  |
| 888    888    "88b888 Y88b888    "88b       "88b88K     d88" 888888     |
| 888    888.d888888888  Y88888.d888888   .d888888"Y8888b.888  888888     |
| 888  .d88P888  888888   Y8888888  888   888  888     X88Y88b 888888     |
| 8888888P" "Y888888888    Y888"Y888888   "Y888888 88888P' "Y88888888     |
|                                                                         |
|                                                                         |
|                                                                         |
| d8b                888           888888                                 |
| Y8P                888           888888                                 |
|                    888           888888                                 |
| 88888888b. .d8888b 888888 8888b. 888888 .d88b. 888d888                  |
| 888888 "88b88K     888       "88b888888d8P  Y8b888P"                    |
| 888888  888"Y8888b.888   .d88888888888888888888888                      |
| 888888  888     X88Y88b. 888  888888888Y8b.    888                      |
| 888888  888 88888P' "Y888"Y888888888888 "Y8888 888                      |
|                                                                         |
|                                                                         |
\                                                                         /
 -------------------------------------------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
EOF
# ============================================================================
# Script Name: install_asdf_packages.sh
# Description: Installs packages using ASDF version manager
# Author: dariush najjarzade
# Creation Date: 2024-07-16
# Last Modified: 2024-07-16
#
# Usage: ./install_asdf_packages.sh <package1> <package2> ...
# Example: ./install_asdf_packages.sh python nodejs rust go kubectl
#
# This script checks if specified packages are installed, and if not,
# uses ASDF to find, add, and install the corresponding plugins.
# It also creates or updates a .tool-versions file with installed packages.
#
# Requirements:
# - ASDF version manager must be installed and configured
# - Internet connection to fetch ASDF plugins and packages
#
# Note: Some packages may require additional system dependencies
# ============================================================================

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if an ASDF plugin is installed
asdf_plugin_exists() {
  asdf plugin list | grep -q "^$1$"
}

# Function to find the correct ASDF plugin for a given package
find_asdf_plugin() {
  local package=$1
  local plugin=$(asdf plugin list all | grep -i "^$package " | head -n 1 | awk '{print $1}')
  if [ -z "$plugin" ]; then
    echo "No ASDF plugin found for $package" >&2
    return 1
  fi
  echo "$plugin"
}

# Check if ASDF is installed
if ! command_exists asdf; then
  echo "ASDF is not installed. Please install ASDF first."
  exit 1
fi

# Read package names from command line arguments
packages=("$@")

if [ ${#packages[@]} -eq 0 ]; then
  echo "Usage: $0 <package1> <package2> ..."
  exit 1
fi

# Process each package
for package in "${packages[@]}"; do
  if command_exists "$package"; then
    echo "$package is already installed."
  else
    echo "$package is not installed. Attempting to install via ASDF..."
    
    plugin=$(find_asdf_plugin "$package")
    if [ $? -ne 0 ]; then
      echo "Skipping $package"
      continue
    fi
    
    if ! asdf_plugin_exists "$plugin"; then
      echo "Adding ASDF plugin for $plugin..."
      asdf plugin add "$plugin"
    fi
    
    echo "Installing latest version of $package..."
    asdf install "$plugin" latest
    asdf global "$plugin" latest
    
    echo "$package installed successfully."
  fi
done

echo "All packages processed. Creating/updating .tool-versions file..."

# Create or update .tool-versions file
for package in "${packages[@]}"; do
  if ! command_exists "$package"; then
    plugin=$(find_asdf_plugin "$package")
    if [ $? -eq 0 ]; then
      version=$(asdf current "$plugin" | awk '{print $2}')
      echo "$plugin $version" >> .tool-versions
    fi
  fi
done

echo "Process completed. Check .tool-versions file for installed packages."            

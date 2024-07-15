#!/bin/bash
cat << EOF
_____________________________________________________________________________                                                                                                                                                            
/ 888888b.  d8b                                                               \                                                                                                                                                           
| 888  "88b Y8P                                                               |                                                                                                                                                           
| 888  .88P                                                                   |                                                                                                                                                           
| 8888888K. 88888888b.  8888b. 888d888888  888                                |                                                                                                                                                           
| 888  "Y88b888888 "88b    "88b888P"  888  888                                |                                                                                                                                                           
| 888    888888888  888.d888888888    888  888                                |                                                                                                                                                           
| 888   d88P888888  888888  888888    Y88b 888                                |                                                                                                                                                           
| 8888888P" 888888  888"Y888888888     "Y88888                                |                                                                                                                                                           
|                                          888                                |                                                                                                                                                           
|                                     Y8b d88P                                |                                                                                                                                                           
|                                      "Y88P"                                 |                                                                                                                                                           
| 8888888b.                              888                     888          |                                                                                                                                                           
| 888  "Y88b                             888                     888          |                                                                                                                                                           
| 888    888                             888                     888          |                                                                                                                                                           
| 888    888 .d88b. 888  888  88888888b. 888 .d88b.  8888b.  .d88888.d8888b   |                                                                                                                                                           
| 888    888d88""88b888  888  888888 "88b888d88""88b    "88bd88" 88888K       |                                                                                                                                                           
| 888    888888  888888  888  888888  888888888  888.d888888888  888"Y8888b.  |                                                                                                                                                           
| 888  .d88PY88..88PY88b 888 d88P888  888888Y88..88P888  888Y88b 888     X88  |                                                                                                                                                           
| 8888888P"  "Y88P"  "Y8888888P" 888  888888 "Y88P" "Y888888 "Y88888 88888P'  |                                                                                                                                                           
|                                                                             |                                                                                                                                                           
|                                                                             |                                                                                                                                                           
\                                                                             /                                                                                                                                                           
 -----------------------------------------------------------------------------                                                                                                                                                            
        \   ^__^                                                                                                                                                                                                                          
         \  (oo)\_______                                                                                                                                                                                                                  
            (__)\       )\/\                                                                                                                                                                                                              
                ||----w |                                                                                                                                                                                                                 
                ||     ||                                                 
EOF
# [Binary Downloads]
#
# This script downloads and installs binaries from specified URLs.
# It supports both tar.gz archives and standalone executables.
#
# Usage:
#   ./update-binaries.sh
#
# Author:
#   dariush najjarzade <dariush@najjarza.de>
#
# Create Date:
#   14-07-2024 14:32:57
#
# Last Modified:
#   14-07-2024 14:32:57
# #!/bin/bash
#
# Functions:
#   - download_targz_binary: Downloads and extracts a tar.gz binary.
#   - download_standalone_binary: Downloads a standalone binary and makes it executable.
#   - binary_exists: Checks if a binary exists and is executable.
#   - get_binary_version: Attempts to get the version of an existing binary.
#   - version_gt: Compares two version strings.
#
# Example:
#   To add a new binary, add an entry to the binaries array in the format:
#   ["binary_name"]="type:url:version"
#   where type is either "targz" or "standalone", and version is the current version.
#

set -e  # Exit immediately if a command exits with a non-zero status.
# set -x  # Print commands and their arguments as they are executed.

# List of binaries to manage
declare -A binaries=(
    ["ripgrep"]="targz:https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz:14.1.0"
    ["assh"]="targz:https://github.com/moul/assh/releases/download/v2.16.0/assh_2.16.0_linux_amd64.tar.gz:2.16.0"
    ["bat"]="targz:https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-i686-unknown-linux-musl.tar.gz:0.24.0"
    ["delta"]="targz:https://github.com/dandavison/delta/releases/download/0.17.0/delta-0.17.0-x86_64-unknown-linux-musl.tar.gz:0.17.0"
    ["eza"]="targz:https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz:0.18.21"
    ["zoxide"]="targz:https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz:0.9.4"
    ["sesh"]="targz:https://github.com/joshmedeski/sesh/releases/download/v1.2.0/sesh_Linux_x86_64.tar.gz:1.2.0"
    ["jq"]="targz:https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz:1.7.1"
    ["ctop"]="standalone:https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64:0.7.7"
)

# Where to copy 
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"


# Function to download and extract tar.gz binary
download_targz_binary() {
    local name=$1
    local url=$2
    local extract_dir=$3

    echo "Downloading and extracting $name from $url"
    wget -q "$url" -O "$name.tar.gz"
    if [ $? -eq 0 ]; then
        echo "Download successful. Extracting..."
        mkdir -p "$extract_dir"
        
        case "$name" in
            ripgrep)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "ripgrep-14.1.0-x86_64-unknown-linux-musl/rg"
                ;;
            bat)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "bat-v0.24.0-i686-unknown-linux-musl/bat"
                ;;
            delta)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "delta-0.17.0-x86_64-unknown-linux-musl/delta"
                ;;                
            *)
                tar -xzf "$name.tar.gz" -C "$extract_dir"
                ;;
        esac
        
        if [ $? -eq 0 ]; then
            echo "Extraction successful. Removing tar.gz file..."
            rm "$name.tar.gz"
            echo "$name successfully downloaded and extracted."
        else
            echo "Failed to extract $name."
            rm "$name.tar.gz"
            return 1
        fi
    else
        echo "Failed to download $name from $url"
        return 1
    fi
}

# Function to download standalone binary
download_standalone_binary() {
    local name=$1
    local url=$2
    local bin_dir=$3

    echo "Downloading $name from $url"
    wget -q "$url" -O "$bin_dir/$name"
    if [ $? -eq 0 ]; then
        chmod +x "$bin_dir/$name"
        echo "$name successfully downloaded and made executable."
    else
        echo "Failed to download $name from $url"
        return 1
    fi
}

# Function to check if binary exists and is executable
binary_exists() {
    local name=$1
    local bin_dir=$2
    [[ -x "$bin_dir/$name" ]]
}

# Function to get binary version
get_binary_version() {
    local name=$1
    local bin_dir=$2
    local version

    case $name in
        ripgrep)
            if [ -x "$bin_dir/rg" ]; then
                version=$("$bin_dir/rg" --version 2>/dev/null | awk '{print $2; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        assh)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $3; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        bat)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        delta)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        ctop)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" -v 2>/dev/null | awk '{print $3; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        zoxide)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        eza)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk NR=='2 {print $1; exit}')
            else
                echo "n/a"
                return
            fi
            ;;
        sesh)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $3; exit}')
            else
                echo "n/a"
                return
            fi
            ;;

        jq)
            if [ -x "$bin_dir/$name" ]; then
                version=$("$bin_dir/$name" --version 2>/dev/null | cut -d "-" -f 2)
            else
                echo "n/a"
                return
            fi
            ;;
        *)
            echo "unknown"
            return
            ;;
    esac

    if [ -z "$version" ]; then
        echo "unknown"
    else
        echo "$version"
    fi
}

# Function to compare versions
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

# Download and extract/copy binaries
for name in "${!binaries[@]}"; do
    echo "Processing $name..."
    
    value="${binaries[$name]}"
    type="${value%%:*}"
    rest="${value#*:}"
    url="${rest%:*}"
    version="${rest##*:}"
    
    current_version=$(get_binary_version "$name" "$BIN_DIR")
    echo "Current version of $name: $current_version"
    if [ "$name" = "assh" ]; then
        echo "Download version of $name:  $version (Online Version)"
        read -p "Do you want to update $name? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Skipping $name update."
            continue
        fi
    else
        echo "Current version of $name: $current_version"
        if [ "$current_version" = "n/a" ] || [ "$current_version" = "unknown" ] || version_gt "$version" "$current_version"; then
            if [ "$current_version" != "n/a" ]; then
                read -p "$name exists (version $current_version). New version ($version) available. Update? (y/n) " -n 1 -r
                echo
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    echo "Skipping $name update."
                    continue
                fi
            fi
        else
            echo "$name is up to date (version $current_version). Skipping download."
            continue
        fi
    fi

    echo "Downloading $name version $version..."
    if [ "$type" == "targz" ]; then
        download_targz_binary "$name" "$url" "$BIN_DIR"
    elif [ "$type" == "standalone" ]; then
        download_standalone_binary "$name" "$url" "$BIN_DIR"
    else
        echo "Unknown type for $name: $type"
    fi
done    

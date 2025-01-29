#!/bin/bash
# Function to check if lolcat is available and set up printing
setup_print() {
    if command -v lolcat >/dev/null 2>&1; then
        print_func() { lolcat; }
    else
        print_func() { cat; }
    fi
}

# Call the setup function
setup_print

cat << EOF | print_func

[38;5;219m╔═══════════════════════════════════════════════════════════════════════════════════════╗[0m
[38;5;219m║[0m[38;5;212m _____________________________________________________________________________________[0m [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m/ 888888b.   d8b                                                                      \[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888  "88b  Y8P                                                                      |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888  .88P                                                                           |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 8888888K.  888 88888b.   8888b.  888d888 888  888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888  "Y88b 888 888 "88b     "88b 888P"   888  888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888    888 888 888  888 .d888888 888     888  888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888   d88P 888 888  888 888  888 888     Y88b 888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 8888888P"  888 888  888 "Y888888 888      "Y88888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m|                                               888                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m|                                          Y8b d88P                                   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m|                                           "Y88P"                                    |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 8888888b.                                  888                        888           |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888  "Y88b                                 888                        888           |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888    888                                 888                        888           |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888    888  .d88b.  888  888  888 88888b.  888  .d88b.   8888b.   .d88888 .d8888b   |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888    888 d88""88b 888  888  888 888 "88b 888 d88""88b     "88b d88" 888 88K       |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888    888 888  888 888  888  888 888  888 888 888  888 .d888888 888  888 "Y8888b.  |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 888  .d88P Y88..88P Y88b 888 d88P 888  888 888 Y88..88P 888  888 Y88b 888      X88  |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m| 8888888P"   "Y88P"   "Y8888888P"  888  888 888  "Y88P"  "Y888888  "Y88888  88888P'  |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m|                                                                                     |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m|                                                                                     |[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m\                                                                                     /[0m[38;5;219m║[0m
[38;5;219m║[0m[38;5;212m -------------------------------------------------------------------------------------[0m [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m        \   ^__^[0m                                                                       [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m         \  (oo)\_______[0m                                                               [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m            (__)\       )\/\[0m                                                           [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m                ||----w |[0m                                                              [38;5;219m║[0m
[38;5;219m║[0m[38;5;212m                ||     ||[0m                                                              [38;5;219m║[0m
[38;5;219m╚═══════════════════════════════════════════════════════════════════════════════════════╝[0m
EOF

#!/bin/bash

# [Binary Downloads]

# This script downloads and installs binaries from specified URLs.
# It supports both tar.gz archives and standalone executables.

# Usage:
# ./update-binaries.sh

# Author:
# dariush najjarzade

# Create Date:
# 14-07-2024 14:32:57

# Last Modified:
# 14-07-2024 14:32:57

set -e # Exit immediately if a command exits with a non-zero status.

# List of binaries to manage
declare -A binaries=(
    ["ripgrep"]="targz:https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-$(uname -m)-unknown-linux-musl.tar.gz:14.1.0"
    ["assh"]="targz:https://github.com/moul/assh/releases/download/v2.16.0/assh_2.16.0_linux_amd64.tar.gz:2.16.0"
    ["atuin"]="targz:https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-v18.3.0-x86_64-unknown-linux-musl.tar.gz:18.3.0"
    ["bat"]="targz:https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz:0.24.0"
    ["delta"]="targz:https://github.com/dandavison/delta/releases/download/0.17.0/delta-0.17.0-x86_64-unknown-linux-musl.tar.gz:0.17.0"
    ["eza"]="targz:https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz:0.18.21"
    ["zoxide"]="targz:https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.4/zoxide-0.9.4-x86_64-unknown-linux-musl.tar.gz:0.9.4"
    ["sesh"]="targz:https://github.com/joshmedeski/sesh/releases/download/v2.0.2/sesh_$(uname)_$(uname -m).tar.gz:2.0.2"
    ["jq"]="targz:https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz:1.7.1"
    ["yq"]="targz:https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64.tar.gz:4.44.3"
    ["ctop"]="standalone:https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64:0.7.7"
    ["teller"]="targz:https://github.com/tellerops/teller/releases/download/v2.0.7/teller-$(uname -m)-linux.tar.xz:2.0.7"
    ["pkgx"]="targz:https://pkgx.sh/$(uname)/$(uname -m).tgz:1.1.6"
)

# Where to copy
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# Function to print messages
print_func() {
    echo "[INFO] $1"
}

# Function to download and extract tar.gz binary
download_targz_binary() {
    local name=$1
    local url=$2
    local extract_dir=$3
    print_func "Downloading and extracting $name from $url"
    wget -q "$url" -O "$name.tar.gz"
    if [ $? -eq 0 ]; then
        print_func "Download successful. Extracting..."
        mkdir -p "$extract_dir"
        case "$name" in
            atuin)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "atuin-v18.3.0-x86_64-unknown-linux-musl/atuin"
                ;;
            ripgrep)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "ripgrep-14.1.0-x86_64-unknown-linux-musl/rg"
                ;;
            bat)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "bat-v0.24.0-x86_64-unknown-linux-musl/bat"
                ;;
            delta)
                tar -xzf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "delta-0.17.0-x86_64-unknown-linux-musl/delta"
                ;;
            yq)
                tar -xzf "$name.tar.gz" -C "$extract_dir" && mv "$extract_dir/yq_linux_amd64" "$extract_dir/yq"
                ;;
            teller)
                tar -xf "$name.tar.gz" -C "$extract_dir" --strip-components=1 "teller-x86_64-linux/teller"
                ;;
            *)
                tar -xzf "$name.tar.gz" -C "$extract_dir"
                ;;
        esac
        if [ $? -eq 0 ]; then
            print_func "Extraction successful. Removing tar.gz file..."
            rm "$name.tar.gz"
            print_func "$name successfully downloaded and extracted."
        else
            print_func "Failed to extract $name."
            rm "$name.tar.gz"
            return 1
        fi
    else
        print_func "Failed to download $name from $url"
        return 1
    fi
}

# Function to download standalone binary
download_standalone_binary() {
    local name=$1
    local url=$2
    local bin_dir=$3
    print_func "Downloading $name from $url"
    wget -q "$url" -O "$bin_dir/$name"
    if [ $? -eq 0 ]; then
        chmod +x "$bin_dir/$name"
        print_func "$name successfully downloaded and made executable."
    else
        print_func "Failed to download $name from $url"
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
            version=$("$bin_dir/rg" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        assh)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $3; exit}')
            ;;
        bat)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        delta)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        ctop)
            version=$("$bin_dir/$name" -v 2>/dev/null | awk '{print $3; exit}')
            ;;
        zoxide)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        eza)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk 'NR==2 {print $1; exit}')
            ;;
        sesh)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $3; exit}')
            ;;
        jq)
            version=$("$bin_dir/$name" --version 2>/dev/null | cut -d "-" -f 2)
            ;;
        yq)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $4; exit}')
            ;;
        pkgx)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        teller)
            version=$("$bin_dir/$name" --version 2>/dev/null | awk '{print $2; exit}')
            ;;
        *)
            version="unknown"
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
    print_func "Processing $name..."
    value="${binaries[$name]}"
    type="${value%%:*}"
    rest="${value#*:}"
    url="${rest%:*}"
    version="${rest##*:}"
    current_version=$(get_binary_version "$name" "$BIN_DIR")
    print_func "Current version of $name: $current_version"
    if [ "$current_version" = "n/a" ] || [ "$current_version" = "unknown" ] || version_gt "$version" "$current_version"; then
        if [ "$current_version" != "n/a" ]; then
            read -p "$name exists (version $current_version). New version ($version) available. Update? (y/n) " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_func "Skipping $name update."
                continue
            fi
        fi
    else
        print_func "$name is up to date (version $current_version). Skipping download."
        continue
    fi
    print_func "Downloading $name version $version..."
    if [ "$type" == "targz" ]; then
        download_targz_binary "$name" "$url" "$BIN_DIR"
    elif [ "$type" == "standalone" ]; then
        download_standalone_binary "$name" "$url" "$BIN_DIR"
    else
        print_func "Unknown type for $name: $type"
    fi
done


#!/bin/bash
# _                    _                                     
#| |_ ___   __ _  __ _| | ___      _ __  _ __ _____  ___   _ 
#| __/ _ \ / _` |/ _` | |/ _ \    | '_ \| '__/ _ \ \/ / | | |
#| || (_) | (_| | (_| | |  __/    | |_) | | | (_) >  <| |_| |
# \__\___/ \__, |\__, |_|\___|____| .__/|_|  \___/_/\_\\__, |
#          |___/ |___/      |_____|_|                  |___/ 
#
#
# Author: dariush najjarzade
# Created: July 5, 2024
# Last Modified: July 10, 2024
#
# toggle_proxy:
# Added a new status action to the function.
# The status action prints out the current values of all proxy-related environment variables.
# Used a case statement for better readability and easier expansion of actions.
# The status function shows "Not set" for variables that are not defined.
#
# Usage:
#
# Setting the proxy:
#
# bash
# toggle_http_proxy set http://proxy.example.com:8080 "localhost,127.0.0.1,.example.com"
#
# Unsetting the proxy:
#
# bash
# toggle_http_proxy unset
#
# Checking proxy status:
#
# bash
# toggle_http_proxy status
#
# Example Output for Status:
# When you run toggle_http_proxy status, you'll see output similar to this:
#
# Current Proxy Settings:
# http_proxy:  http://proxy.example.com:8080
# https_proxy: http://proxy.example.com:8080
# all_proxy:   http://proxy.example.com:8080
# no_proxy:    localhost,127.0.0.1,.example.com
# HTTP_PROXY:  http://proxy.example.com:8080
# HTTPS_PROXY: http://proxy.example.com:8080
# ALL_PROXY:   http://proxy.example.com:8080
# NO_PROXY:    localhost,127.0.0.1,.example.com
#
# If no proxy is set, it will show:
#
# Current Proxy Settings:
# http_proxy:  Not set
# https_proxy: Not set
# all_proxy:   Not set
# no_proxy:    Not set
# HTTP_PROXY:  Not set
# HTTPS_PROXY: Not set
# ALL_PROXY:   Not set
# NO_PROXY:    Not set
#
# This enhanced version of the function provides a comprehensive way to manage and view your proxy settings in the shell environment. Remember to add this function to your .bashrc or .bash_profile file and source it or restart your terminal for the changes to take effect.
# Related
# How can I create a status function to display current variables in bash
# What is the best way to format the output of a status function in bash
# Can I use the declare command to show current variables in bash
# How do I integrate a status function into an existing bash script
# Is it possible to update the status function dynamically in bash
#
function toggle_proxy() {
    local action=$1
    local proxy_url=http://192.168.1.12:8081
    local no_proxy_list=192.168.1.0/24,localhost,git.najjarza.de,*.najjarza.de
    # local proxy_url=$2
    # local no_proxy_list=$3

    case "$action" in
        set)
            if [[ -z "$proxy_url" ]]; then
                echo "Error: Proxy URL is required to set the proxy."
                return 1
            fi
            export http_proxy="$proxy_url"
            export https_proxy="$proxy_url"
            export all_proxy="$proxy_url"
            export HTTP_PROXY="$proxy_url"
            export HTTPS_PROXY="$proxy_url"
            export ALL_PROXY="$proxy_url"
            
            if [[ -n "$no_proxy_list" ]]; then
                export no_proxy="$no_proxy_list"
                export NO_PROXY="$no_proxy_list"
                echo "Proxy set to $proxy_url with no_proxy: $no_proxy_list"
            else
                echo "Proxy set to $proxy_url"
            fi
            ;;
        unset)
            unset http_proxy https_proxy all_proxy no_proxy
            unset HTTP_PROXY HTTPS_PROXY ALL_PROXY NO_PROXY
            echo "All proxy settings unset"
            ;;
        status)
            echo "Current Proxy Settings:"
            echo "http_proxy:  ${http_proxy:-Not set}"
            echo "https_proxy: ${https_proxy:-Not set}"
            echo "all_proxy:   ${all_proxy:-Not set}"
            echo "no_proxy:    ${no_proxy:-Not set}"
            echo "HTTP_PROXY:  ${HTTP_PROXY:-Not set}"
            echo "HTTPS_PROXY: ${HTTPS_PROXY:-Not set}"
            echo "ALL_PROXY:   ${ALL_PROXY:-Not set}"
            echo "NO_PROXY:    ${NO_PROXY:-Not set}"
            ;;
        *)
            echo "Usage: toggle_proxy {set|unset|status} [proxy_url] [no_proxy_list]"
            echo "Example: toggle_proxy set http://proxy.example.com:8080 'localhost,127.0.0.1'"
            return 1
            ;;
    esac
}
# Function: sssh
# Description: SSH host selector and connector using assh and fzf
# Usage: sssh [pattern]
#   [pattern] : Optional search pattern to filter hosts
#
# Author: dariush najjarzade
# Created: July 10, 2024
# Last Modified: July 10, 2024
#
# This function allows easy selection and connection to SSH hosts managed by assh.
# It uses fzf for interactive host selection and supports optional pattern filtering.
#
#             _     
# ___ ___ ___| |__  
#/ __/ __/ __| '_ \ 
#\__ \__ \__ \ | | |
#|___/___/___/_| |_|
#                   
# ssh host select and connect

sssh() {
    local pattern="$1"
    local cmd="assh config"

    # Determine whether to list all hosts or search with a pattern
    if [ -n "$pattern" ]; then
        cmd="$cmd search $pattern"
    else
        cmd="$cmd list"
    fi

    # Use fzf to interactively select a host
    local selected_host=$(eval "$cmd" | grep ">" | print_with_colors | \
        fzf --ansi --delimiter=":" \
            --color \
            --with-nth=1 \
            --preview='echo {1}:{2} | bat --color=always -l bash ' \
            --header='Line:Host' | \
        cut -d: -f1 | \
        awk '{print $3}')
    
    # Connect to the selected host or display a message if none selected
    if [ -n "$selected_host" ]; then
        ssh "$selected_host"
    else
        echo "No host selected."
    fi
}                 
#
# _               _              
#| |__   __ _ ___| |__  _ __ ___ 
#| '_ \ / _` / __| '_ \| '__/ __|
#| |_) | (_| \__ \ | | | | | (__ 
#|_.__/ \__,_|___/_| |_|_|  \___|
#
# Function: bashrc
# Description: Edit and automatically source bash configuration files
# Usage: bashrc [option]
#   Options:
#     (no option) : Edit ~/.bashrc
#     a, alias, aliases : Edit ~/.bash_aliases
#     f, func, functions : Edit ~/.bash_functions
#     p, prof, profile : Edit ~/.profile
# 
# Author: dariush najjarzade
# Created: July 10, 2024
# Last Modified: July 12, 2024
#
# This function allows easy editing of .bashrc, .bash_aliases, and .bash_functions
# files using vim. After editing, it automatically sources the file if changes
# were made, eliminating the need to manually source after each edit.

bashrc() {
    local file_to_edit=""
    local file_name=""

    # Determine which file to edit based on the argument
    case "$1" in
        "a" | "alias" | "aliases")
            file_to_edit="$HOME/.bash_aliases"
            file_name="bash_aliases"
            ;;
        "f" | "func" | "functions")
            file_to_edit="$HOME/.bash_functions"
            file_name="bash_functions"
            ;;
        "p" | "prof" | "profile")
            file_to_edit="$HOME/.profile"
            file_name="profile"
            ;;
        *)
            file_to_edit="$HOME/.bashrc"
            file_name="bashrc"
            ;;
    esac

    # Create the file if it doesn't exist
    if [ ! -f "$file_to_edit" ]; then
        echo "File $file_to_edit does not exist. Creating it..."
        touch "$file_to_edit"
    fi

    # Calculate MD5 hash before editing
    local original_md5=$(md5sum "$file_to_edit" | cut -d ' ' -f 1)
    
    # Open the file in vim for editing
    vim "$file_to_edit"
    
    # Calculate MD5 hash after editing
    local new_md5=$(md5sum "$file_to_edit" | cut -d ' ' -f 1)
    
    # Check if the file was modified
    if [ "$original_md5" != "$new_md5" ]; then
        echo "Changes detected in .$file_name. Sourcing the file..."
        source "$file_to_edit"
        echo ".$file_name has been reloaded."
    else
        echo "No changes detected in .$file_name."
    fi
}
#
#           _                  _   
#  _____  _| |_ _ __ __ _  ___| |_ 
# / _ \ \/ / __| '__/ _` |/ __| __|
#|  __/>  <| |_| | | (_| | (__| |_ 
# \___/_/\_\\__|_|  \__,_|\___|\__|
#                                  
# extract() - Extract various archive formats
#
# Usage: extract <file>
#
# This function extracts various archive formats based on the file extension.
# It supports the following formats:
#   - tar.gz, tar.lz, tar.xz, tar.bz2, tar.bz, tar.Z, tar.zst (bsdtar)
#   - 7z (7z)
#   - Z (uncompress)
#   - bz2 (bunzip2)
#   - exe (cabextract)
#   - gz (gunzip)
#   - rar (unrar)
#   - xz (unxz)
#   - zip (unzip)
#   - zst (unzstd)
#
# Author: dariush najjarzade
# Created: July 11, 2024
# Last Modified: July 11, 2024
#
# Enable extended globbing
shopt -s extglob

extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz|zst)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *.zst) c=(unzstd);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}
#
#
#
# Function to print with alternating colors
print_with_colors() {
  local colors=("\033[33m" "\033[34m") # Yellow and Blue
  local reset_color="\033[0m"
  local i=0

  while IFS= read -r line; do
    echo -e "${colors[$((i % 2))]}$line${reset_color}"
    i=$((i + 1))
  done
}
#
# _                    _                         _ _   
#| |_ ___   __ _  __ _| | ___  __   ____ _ _   _| | |_ 
#| __/ _ \ / _` |/ _` | |/ _ \ \ \ / / _` | | | | | __|
#| || (_) | (_| | (_| | |  __/  \ V / (_| | |_| | | |_ 
# \__\___/ \__, |\__, |_|\___|___\_/ \__,_|\__,_|_|\__|
#          |___/ |___/      |_____|                    
#
# Author: dariush najjarzade
# Created: July 13, 2024
# Last Modified: July 13, 2024
#
# Function to toggle Ansible Vault encryption/decryption
#
# Usage: toggle_vault [file]
#
toggle_vault() {
    local VAULT_FILE=$1

    # Check if a file path is provided
    if [ -z "$VAULT_FILE" ]; then
        echo "Usage: toggle_vault <vault_file>"
        return 1
    fi

    # Check if the file exists
    if [ ! -f "$VAULT_FILE" ]; then
        echo "Error: File $VAULT_FILE does not exist."
        return 1
    fi

    # Check if the file is encrypted or not
    if ansible-vault view --vault-password-file ~/.ansible_vault_password "$VAULT_FILE" > /dev/null 2>&1; then
        # File is encrypted, decrypt it
        ansible-vault decrypt --vault-password-file ~/.ansible_vault_password "$VAULT_FILE"
        echo "File decrypted: $VAULT_FILE"
    else
        # File is not encrypted, encrypt it
        ansible-vault encrypt --vault-password-file ~/.ansible_vault_password "$VAULT_FILE"
        echo "File encrypted: $VAULT_FILE"
    fi
}

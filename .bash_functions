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
# Last Modified: July 19, 2024
# Function to enable extended globbing based on the shell
enable_extended_globbing() {
    if [ -n "$ZSH_VERSION" ]; then
        setopt extendedglob
    elif [ -n "$BASH_VERSION" ]; then
        shopt -s extglob
    fi
}

# Enable extended globbing
enable_extended_globbing

extract() {
    local c e i

    (($#)) || return

    for i in "$@"; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
            *.tar.gz|*.tgz|*.tar.lz|*.tar.xz|*.tar.bz2|*.tar.bz|*.tar.az|*.tar.ar|*.tar.arZ|*.tar.arbz|*.tar.arbz2|*.tar.argz|*.tar.arlzma|*.tar.arxz|*.tar.arzst)
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
        e=$((e || $?))
    done
    return "$e"
}
#
#             _       _              _ _   _                 _            
#  _ __  _ __(_)_ __ | |_  __      _(_) |_| |__     ___ ___ | | ___  _ __ 
# | '_ \| '__| | '_ \| __| \ \ /\ / / | __| '_ \   / __/ _ \| |/ _ \| '__|
# | |_) | |  | | | | | |_   \ V  V /| | |_| | | | | (_| (_) | | (_) | |   
# | .__/|_|  |_|_| |_|\__|   \_/\_/ |_|\__|_| |_|  \___\___/|_|\___/|_|   
# |_|                                                                     
# 
# Author: dariush najjarzade
# Created: July 10, 2024
# Last Modified: July 18, 2024
#
# Function to print with alternating colors
print_with_colors() {
  local ir=("\033[32m" "\033[97m" "\033[31m")      # Green, White, Red (Italy)
  local ukraine=("\033[33m" "\033[34m")            # Yellow and Blue (Ukraine)
  local de=("\033[30;47m" "\033[31m" "\033[33m")   # Black on White, Red, Gold (Germany)
  local ru=("\033[97m" "\033[34m" "\033[31m")      # White, Blue, Red (Russia)
  local fr=("\033[34m" "\033[97m" "\033[31m")      # Blue, White, Red (France)

  local colors=("${ir[@]}") # Default to Italian flag colors
  local reset_color="\033[0m"
  local i=0

  # Check if a color set is specified as an argument
  local arg="${1:-}"
  arg=$(echo "$arg" | tr '[:upper:]' '[:lower:]')

  case "$arg" in
    "ukraine") colors=("${ukraine[@]}") ;;
    "de") colors=("${de[@]}") ;;
    "ru") colors=("${ru[@]}") ;;
    "fr") colors=("${fr[@]}") ;;
    "ir"|"") colors=("${ir[@]}") ;; # Default to Italian if no arg or "ir" is specified
    *) echo "Invalid color set. Using default (Italian)." >&2 ;;
  esac

  local color_count=${#colors[@]}

  while IFS= read -r line; do
    printf "%b%s%b\n" "${colors[$((i % color_count))]}" "$line" "$reset_color"
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
#
#  __ _       _   _                       _ _       _     _     _                   
# / _| | __ _| |_| |_ ___ _ __       __ _(_) |_    | |__ (_)___| |_ ___  _ __ _   _ 
#| |_| |/ _` | __| __/ _ \ '_ \     / _` | | __|   | '_ \| / __| __/ _ \| '__| | | |
#|  _| | (_| | |_| ||  __/ | | |   | (_| | | |_    | | | | \__ \ || (_) | |  | |_| |
#|_| |_|\__,_|\__|\__\___|_| |_|____\__, |_|\__|___|_| |_|_|___/\__\___/|_|   \__, |
#                             |_____|___/     |_____|                         |___/ 
#
# Author: dariush najjarzade
# Created: July 14, 2024
# Last Modified: July 14, 2024
#
# This will keep the two most recent commits intact and consolidate all older commits into a single commit with a message that includes the date of the change, the Git username, and the Git email. 
# Be cautious with the --force push, especially if working on a shared branch.
#
#
flatten_git_history() {
    # Get the current branch name
    current_branch=$(git symbolic-ref --short HEAD)
    
    # Check if there are at least three commits in the repository
    commit_count=$(git rev-list --count HEAD)
    if [ "$commit_count" -lt 4 ]; then
        echo "Not enough commits to flatten. The repository must have at least three commits."
        return 1
    fi
    
    # Get the SHA of the commit before the last two commits
    third_to_last_commit=$(git rev-list --skip=2 --max-count=1 HEAD)
    
    # Create a temporary branch from the third to last commit
    git checkout -b temp-branch $third_to_last_commit
    
    # Get the current date
    current_date=$(date +"%Y-%m-%d")
    
    # Get the Git user name and email
    git_user_name=$(git config user.name)
    git_user_email=$(git config user.email)
    
    # Create a single commit with the message "[Flatten history: $current_date]" and user details
    commit_message="[Flatten history: $current_date]  Git user: $git_user_name  Git email: $git_user_email"
    git reset --soft $(git commit-tree HEAD^{tree} -m "$commit_message")
    
    # Checkout the current branch and rebase the temporary branch onto the latest commit
    git checkout $current_branch
    git rebase --onto temp-branch HEAD~2 HEAD
    
    # Delete the temporary branch
    git branch -D temp-branch
    
    # Force push the changes to the original branch
    git push origin $current_branch --force
    
    echo "History has been flattened. All commits except the last two have been squashed into a single commit with the message '[Flatten history: $current_date]'."
}
# add_alias
# Easy add alias with aalias key=value
add_alias() {
    KEY=$(echo $1 | cut -d"=" -f 1)
    VALUE=$(echo $1 | cut -d"=" -f 2-)
    echo -e "\nalias $KEY='$VALUE'" >> ~/.bash_aliases
    echo "New permanent bash alias set: alias $KEY='$VALUE'"
    if [ -f ~/.bash_aliases ]; then
            . ~/.bash_aliases
        fi
}
# pkgs magic command
# it was removed due to unsolvable issues
function command_not_found_handle {
  pkgx -- "$*"
}
# NOTE in zsh append an `r` ie `command_not_found_handler``
# 
## Enhanced SSH Host Completion Function
## Author: dariush najjarzade
## Last Updated: July 19, 2024

_complete_hosts() {
    local cur cache_file cache_age max_cache_age
    local -a host_list

    cur="${COMP_WORDS[COMP_CWORD]}"
    cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/ssh_hosts_cache"
    max_cache_age=3600  # Cache expires after 1 hour

    # Function to generate the host list
    generate_host_list() {
        {
            # SSH config files
            for c in /etc/ssh_config /etc/ssh/ssh_config ~/.ssh/config "${SSH_CONFIG_EXTRA_FILES[@]}"; do
                [[ -r "$c" ]] && awk '/^Host|^[[:space:]]*HostName/ {print $2}' "$c"
            done

            # Known hosts files
            # for k in /etc/ssh_known_hosts /etc/ssh/ssh_known_hosts ~/.ssh/known_hosts "${SSH_KNOWN_HOSTS_EXTRA_FILES[@]}"; do
                # [[ -r "$k" ]] && awk '!/^[#\[]/ {print $1}' "$k" | sed -e 's/[,:].*//g'
            # done

            # /etc/hosts
            # awk '/^[0-9]/ {for (i=2; i<=NF; i++) print $i}' /etc/hosts

            # Custom host list
            [[ -n "$SSH_CUSTOM_HOST_LIST" ]] && echo "$SSH_CUSTOM_HOST_LIST"
        } | sort -u | grep -v '\*' | grep -v '^$'
    }

    # Check if cache exists and is fresh
    if [[ -f "$cache_file" ]]; then
        cache_age=$(($(date +%s) - $(stat -c %Y "$cache_file")))
        if (( cache_age < max_cache_age )); then
            mapfile -t host_list < "$cache_file"
        fi
    fi

    # Regenerate cache if necessary
    if (( ${#host_list[@]} == 0 )); then
        mapfile -t host_list < <(generate_host_list)
        mkdir -p "$(dirname "$cache_file")"
        printf '%s\n' "${host_list[@]}" >| "$cache_file"
    fi

    if command -v fzf >/dev/null 2>&1; then
        # Use fzf interactively
        selected_host=$(printf '%s\n' "${host_list[@]}" | fzf --height 40% --reverse --query="$cur" --select-1 --exit-0)
        if [[ -n $selected_host ]]; then
            COMPREPLY=("$selected_host")
        fi
    else
        # Fallback to basic completion
        COMPREPLY=($(compgen -W "${host_list[*]}" -- "$cur"))
    fi

    return 0
}

# Set up the completion
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -U +X compinit && compinit
    compdef _complete_hosts ssh scp sftp
else
    complete -F _complete_hosts ssh scp sftp
fi

# Configuration (can be overridden in .bashrc or .bash_profile)
SSH_CONFIG_EXTRA_FILES=()
SSH_KNOWN_HOSTS_EXTRA_FILES=()
SSH_CUSTOM_HOST_LIST=""


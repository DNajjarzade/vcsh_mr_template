#!/bin/bash

#  _____________________________________________________________________________________________
# / 8888888b.         888b    888              888                     888                      \
# | 888  "Y88b        8888b   888              888                     888                      |
# | 888    888        88888b  888              888                     888                      |
# | 888    888 8888b. 888Y88b 888 8888b.       88888b.  8888b. .d8888b 88888b. 888d888 .d8888b  |
# | 888    888    "88b888 Y88b888    "88b      888 "88b    "88b88K     888 "88b888P"  d88P"     |
# | 888    888.d888888888  Y88888.d888888      888  888.d888888"Y8888b.888  888888    888       |
# | 888  .d88P888  888888   Y8888888  888   d8b888 d88P888  888     X88888  888888    Y88b.     |
# | 8888888P" "Y888888888    Y888"Y888888   Y8P88888P" "Y888888 88888P'888  888888     "Y8888P  |
# |                                                                                             |
# |                                                                                             |
# \                                                                                             /
#  ---------------------------------------------------------------------------------------------
#         \   ^__^
#          \  (oo)\_______
#             (__)\       )\/\
#                 ||----w |
#                 ||     ||
# .bashrc - Bash Configuration File
# Description: Configuration and customization for the Bash shell.
# Author: dariush najjarzade
# Created on: 2024-06-15
# Modified on: 2024-07-15

# Check if the shell is interactive, and return if it isn't
case $- in
  *i*) ;;
    *) return;;
esac

# Source other Bash configuration files
files_to_source=(
    "$HOME/.bash_aliases"
    "$HOME/.bash_functions"
    "$HOME/.bash_completions"
)

for file in "${files_to_source[@]}"; do
    [ -f "$file" ] && source "$file"
done

# Oh My Bash Configuration
export OSH=~/.oh-my-bash
OSH_THEME="font"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
OMB_USE_SUDO=true
OMB_PROMPT_SHOW_PYTHON_VENV=true

[[ $- = *i* ]] && source "$OSH/oh-my-bash.sh"
[[ $- = *i* ]] && source ~/.config/liquidpromptrc

# Man page configuration
export MANPATH="/usr/local/man:$MANPATH"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="TwoDark"
alias bathelp='bat --plain --language=cmd-help'

help() (
    set -o pipefail
    "$@" --help 2>&1 | bathelp
)

# Set editor based on whether in SSH session
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Alias for SSH with assh wrapper
alias ssh="assh wrapper ssh --"

# Initialize zoxide if installed
if command -v zoxide >/dev/null; then
  eval "$(zoxide init bash)"
fi

# Initialize fzf if installed
if [ -f ~/.fzf.bash ]; then
  . ~/.fzf.bash
  eval "$(fzf --bash)"
fi

# Source fzf-git script if it exists
if [ -f "$HOME/fzf-git.sh/fzf-git.sh" ]; then
  . "$HOME/fzf-git.sh/fzf-git.sh"
fi

# Source .bash_functions if it exists
if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bash_functions" ]; then
    . "$HOME/.bash_functions"
fi

# add asdf
if [ -f  "$HOME/.asdf/asdf.sh"]; then
  . "$HOME/.asdf/asdf.sh"
fi

if [-f  "$HOME/.asdf/completions/asdf.bash"]; then
  . "$HOME/.asdf/completions/asdf.bash"
fi

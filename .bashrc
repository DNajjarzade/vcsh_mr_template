#!/bin/bash

#    _               _              
#   | |__   __ _ ___| |__  _ __ ___ 
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__ 
# (_)_.__/ \__,_|___/_| |_|_|  \___|
#                                   
# .bashrc - User's Bash Configuration File
# Description: Configuration and customization for the Bash shell.
# Author: dariush najjarzade
# Created on: 

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

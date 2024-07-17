# 
# Common shortcuts
#
alias _='sudo '
alias a='alias | print_with_colors | fzf --ansi --color --tac --preview "echo {}" | sed "s/alias \([^=]*\)=.*/\1/" | xargs -I {} bash -ic "{}"'
# alias c='bat --color=always --style=numbers'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias s='sssh'
alias aalias='add_alias'
alias svim='vim -u ~/.SpaceVim/vimrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowd='date +"%d-%m-%Y"'
alias nowdate='date +"%d-%m-%Y" ; date +"%T"'
alias emacs='/usr/bin/emacsclient -c -a '\''emacs'\'''
alias joplinc='~/.joplin-bin/bin/joplin'
alias home-manager='nix --extra-experimental-features nix-command --extra-experimental-features flakes  run  home-manager $@'
alias ik3c-vpn='sudo openvpn --config ~/.config/k3c/d.najarzadeh@irankish.com__ssl_vpn_config.ovpn'
alias asdf-install='~/.local/bin-repo/install_asdf_packages.sh '
alias bin-repo='vcsh bin-repo commit -m "$1" && vcsh bin-repo push'
#
# firewall aliases
#
alias ipt='sudo /sbin/iptables' # shortcut  for iptables and pass it via sudo
# display all rules #
alias iptlist='ipt -L -n -v --line-numbers'
alias iptlistin='ipt -L INPUT -n -v --line-numbers'
alias iptlistout='ipt -L OUTPUT -n -v --line-numbers'
alias iptlistfw='ipt -L FORWARD -n -v --line-numbers'
alias firewall=iptlist
#
# kubernetes aliases
#
alias k='/usr/local/bin/kubectl'
alias kdp='k get pods --all-namespaces | fzf | awk '\''{print $1 }'\'' | xargs -n1 kubectl describe pod '
alias argo_pass='kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d'
#
# docker aliases
#
alias d='/usr/bin/docker'
alias dc='/usr/bin/docker-compose'
alias dcu='dc up -d'
alias dcd='dc down'
alias dcr='dc down & sleep 3 & dc up -d'
alias dcl='dc logs -f'
#
# tmux aliases
#
alias tm='tmux' #	Start tmux.
# alias tma='tm attach-session' #	Attach to a tmux session.
alias tma='tm attach-session -t' #	Attach to a tmux session with name.
alias tmk='tm kill-session -t' #	Kill all tmux sessions.
alias tml='tm list-sessions' # List tmux sessions.
alias tmn='tm new-session' 	# Start a new tmux session.
alias tmns='tm new -s' #	Start a new tmux session with name.
alias tms='tm new-session -s' #	Start a new tmux session.
#
# eza aliases 
#
alias ld='eza -lD' # ld — lists only directories (no files)
alias lf='eza -lf --color=always | grep -v /' # lf — lists only files (no directories)
alias lh='eza -dl .* --group-directories-first' # lh — lists only hidden files (no directories)
alias ll='eza -al --group-directories-first' # ll — lists everything with directories first
alias la='eza -alf --color=always --sort=size | grep -v /' # la — lists only files sorted by size
alias lt='eza -al --sort=modified' # lt — lists everything sorted by time updated
#
# git aliases 
#
alias g='git '
alias cg='cd `git rev-parse --show-toplevel`'
alias gs='g status '
alias ga='g add –verbose '
alias gco='g checkout '
alias gls='g ls-files '
alias gpa='g push –all '
# alias grep='grep –color=auto'
alias gca='g commit –all '
alias gc='g commit -v '

alias motd='~/fancy-motd/motd.sh'

alias gum='pkgx gum'

alias git-stage='~/.local/bin-repo/git-stage.sh'

alias git-commit='~/.local/bin-repo/git-commit.sh'

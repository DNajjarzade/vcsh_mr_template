alias emacs="/usr/bin/emacsclient -c -a 'emacs'"
alias joplinc='~/.joplin-bin/bin/joplin'
alias cat='bat'
alias k='/usr/local/bin/kubectl'
alias kdp="k get pods --all-namespaces | fzf | awk '{print $1 }' | xargs -n1 kubectl describe pod "
alias d='/usr/bin/docker'
alias dc='/usr/bin/docker-compose'
alias dcu='dc up -d'
alias dcl='dc logs -f'
alias home-manager='nix --extra-experimental-features nix-command --extra-experimental-features flakes  run  home-manager $@'
alias ik3c-vpn='sudo openvpn --config ~/.config/k3c/d.najarzadeh@irankish.com__ssl_vpn_config.ovpn'
alias argo_pass='kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d'
#
# tmux aliases
#
alias tm='tmux' #	Start tmux.
# alias tma='tmux attach-session' #	Attach to a tmux session.
alias tma='tmux attach-session -t' #	Attach to a tmux session with name.
alias tmk='tmux kill-session -t' #	Kill all tmux sessions.
alias tml='tmux list-sessions' # List tmux sessions.
alias tmn='tmux new-session' 	# Start a new tmux session.
alias tmns='tmux new -s' #	Start a new tmux session with name.
alias tms='tmux new-session -s' #	Start a new tmux session.
#
# eza aliases 
#
ld='eza -lD' # ld — lists only directories (no files)
lf='eza -lf --color=always | grep -v /' # lf — lists only files (no directories)
lh='eza -dl .* --group-directories-first' # lh — lists only hidden files (no directories)
ll='eza -al --group-directories-first' # ll — lists everything with directories first
la='eza -alf --color=always --sort=size | grep -v /' # la — lists only files sorted by size
lt='eza -al --sort=modified' # lt — lists everything sorted by time updated

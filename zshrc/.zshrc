# Completion
setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

# ─────────────────────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/timour/.rd/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$PATH:/Users/timour/.local/bin"
export PATH="$PATH:$(go env GOPATH 2>/dev/null)/bin"

# ─────────────────────────────────────────────────────────────────────────────
# PLUGINS & TOOLS
# ─────────────────────────────────────────────────────────────────────────────
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

# ─────────────────────────────────────────────────────────────────────────────
# KEYBINDINGS
# ─────────────────────────────────────────────────────────────────────────────
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
bindkey jj vi-cmd-mode

# ─────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT
# ─────────────────────────────────────────────────────────────────────────────
export LANG=en_US.UTF-8
export EDITOR=/opt/homebrew/bin/nvim
export GITHUB_USER=Tim275

# ─────────────────────────────────────────────────────────────────────────────
# KUBERNETES (Talos Homelab)
# ─────────────────────────────────────────────────────────────────────────────
export KUBECONFIG="/Users/timour/Desktop/kubecraft/mealie/homelabtm/taloshomelab/talos-homelab-scratch/tofu/output/kube-config.yaml"
export TALOSCONFIG="/Users/timour/Desktop/kubecraft/mealie/homelabtm/taloshomelab/talos-homelab-scratch/tofu/output/talos-config.yaml"

source <(kubectl completion zsh)
compdef k=kubectl

# Kubecolor wrapper
if command -v kubecolor &> /dev/null; then
  function kubectl() { command kubecolor "$@"; }
fi

# K8s Aliases
alias k="kubectl"
alias ka="kubectl apply -f"
alias kd="kubectl describe"
alias kdel="kubectl delete"
alias kg="kubectl get"
alias kgpo="kubectl get pods"
alias kgpow="kubectl get pods -o wide"
alias kgd="kubectl get deployments"
alias kgsvc="kubectl get services"
alias kl="kubectl logs -f"
alias ke="kubectl exec -it"
alias kns="kubens"
alias kc="kubectx"
alias kcns='kubectl config set-context --current --namespace'

# Cluster switcher
alias k8s-talos='export KUBECONFIG=/Users/timour/Desktop/kubecraft/mealie/homelabtm/taloshomelab/talos-homelab-scratch/tofu/output/kube-config.yaml && echo "Talos Homelab" && kubectl get nodes'
alias k8s-k3s='export KUBECONFIG=~/.kube/config.backup && echo "k3s Rancher" && kubectl get nodes'

# ─────────────────────────────────────────────────────────────────────────────
# GIT
# ─────────────────────────────────────────────────────────────────────────────
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gr='git remote'
alias gre='git reset'

# ─────────────────────────────────────────────────────────────────────────────
# DOCKER
# ─────────────────────────────────────────────────────────────────────────────
docker context use rancher-desktop >/dev/null 2>&1
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# ─────────────────────────────────────────────────────────────────────────────
# NAVIGATION & FILES
# ─────────────────────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias ls='colorls --group-directories-first'
alias ll='colorls -la --group-directories-first'
alias la='colorls -a --group-directories-first'
alias lt='colorls --tree=2'
alias cat='bat --style=auto'

# FZF navigation (Omer style)
cx() { cd "$@" && ls; }
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && ls; }
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | pbcopy; }
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }

# ─────────────────────────────────────────────────────────────────────────────
# TOOLS
# ─────────────────────────────────────────────────────────────────────────────
alias v='nvim'
alias vim='nvim'
alias lg='lazygit'
alias ld='lazydocker'
alias top='btop'
alias cl='clear'
alias http="xh"

# ─────────────────────────────────────────────────────────────────────────────
# CLAUDE CODE
# ─────────────────────────────────────────────────────────────────────────────
alias claude-k8s="claude --append-system-prompt 'Focus on Kubernetes/Cilium troubleshooting'"

# ─────────────────────────────────────────────────────────────────────────────
# TMUX
# ─────────────────────────────────────────────────────────────────────────────
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tk='tmux kill-session -t'

# ─────────────────────────────────────────────────────────────────────────────
# FZF
# ─────────────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ─────────────────────────────────────────────────────────────────────────────
# OVERRIDE (must be at end to take precedence)
# ─────────────────────────────────────────────────────────────────────────────
unalias ls 2>/dev/null
alias ls='colorls --group-directories-first'

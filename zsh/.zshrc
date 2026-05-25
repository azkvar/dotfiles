export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
)
source "$ZSH/oh-my-zsh.sh"

eval "$(mise activate zsh)"
export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
source "$HOME/.cargo/env"

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

alias cat='bat'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree --level=2'
alias cd='z'
alias g='git'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias lg='lazygit'
alias vi='nvim'
alias vim='nvim'

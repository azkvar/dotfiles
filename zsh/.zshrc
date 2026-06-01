source_if_exists() {
    [[ -f "$1" ]] && source "$1"
}

export DOTFILES="$HOME/.dotfiles"

if [[ -d /opt/homebrew ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local ]]; then
    HOMEBREW_PREFIX="/usr/local"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
compinit

export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
source "$HOME/.cargo/env"

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
    source_if_exists "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.plugin.zsh"
    source_if_exists "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

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

if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

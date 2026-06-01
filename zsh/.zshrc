source_if_exists() {
    [[ -f "$1" ]] && source "$1"
}

export DOTFILES="$HOME/.dotfiles"

HOMEBREW_PREFIX="/opt/homebrew"

if [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

autoload -Uz compinit
compinit

export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
source_if_exists "$HOME/.cargo/env"

if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
fi

if [[ -d "$HOMEBREW_PREFIX" ]]; then
    source_if_exists "$HOMEBREW_PREFIX/share/fzf-tab/fzf-tab.plugin.zsh"
    source_if_exists "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    source_if_exists "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
    alias lt='eza --tree --level=2'
fi

alias g='git'
alias gs='git status'
alias gp='git push'
alias gl='git pull'

if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

source_if_exists "$HOME/.zshrc.local"

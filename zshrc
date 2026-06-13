export ZSH="$HOME/.oh-my-zsh"
export DOTFILES_DIR="$HOME/dotfiles"

plugins=(
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
alias cat='bat --paging=never'
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree --level=2'

eval "$(mise activate zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
eval "$(starship init zsh)"

code-extensions() {
  code --list-extensions | sort > "$DOTFILES_DIR/vscode_extensions.txt"
}

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

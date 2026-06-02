fpath=("/opt/homebrew/share/zsh-completions" $fpath)

autoload -Uz compinit
compinit

source "/opt/homebrew/share/fzf-tab/fzf-tab.zsh"
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

eval "$(mise activate zsh)"

eval "$(zoxide init zsh)"
alias cd='z'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

eval "$(fzf --zsh)"

alias cat='bat --paging=never'

alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree --level=2'

eval "$(starship init zsh)"

source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

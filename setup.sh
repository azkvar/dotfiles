#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

brew bundle --file="$DOTFILES_DIR/Brewfile" --no-upgrade

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

mkdir -p "$HOME/.config/ghostty" "$HOME/.config/zed"
mkdir -p "$HOME/Library/Application Support/Code/User"

ln -sfn "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"
ln -sfn "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
ln -sfn "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore_global"
ln -sfn "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES_DIR/ghostty_config" "$HOME/.config/ghostty/config"
ln -sfn "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$DOTFILES_DIR/zed_settings.json" "$HOME/.config/zed/settings.json"
ln -sfn "$DOTFILES_DIR/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

if command -v code >/dev/null; then
  while IFS= read -r extension; do
    [[ -z "$extension" || "$extension" == \#* ]] && continue
    code --install-extension "$extension" >/dev/null
  done < "$DOTFILES_DIR/vscode_extensions.txt"
fi

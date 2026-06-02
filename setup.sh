#!/bin/bash
set -euo pipefail
brew bundle --file="Brewfile" --no-upgrade
mkdir -p "$HOME/.config/ghostty" "$HOME/.config/zed"
ln -sfn "$PWD/zsh/.zshrc" "$HOME/.zshrc"
ln -sfn "$PWD/git/.gitconfig" "$HOME/.gitconfig"
ln -sfn "$PWD/ghostty/config" "$HOME/.config/ghostty/config"
ln -sfn "$PWD/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$PWD/zed/settings.json" "$HOME/.config/zed/settings.json"

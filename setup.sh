#!/bin/bash
set -euo pipefail

brew bundle --file="Brewfile" --no-upgrade

mkdir -p "$HOME/.config/fish/conf.d" "$HOME/.config/fish/functions" "$HOME/.config/fish/completions"
mkdir -p "$HOME/.config/ghostty" "$HOME/.config/zed"

ln -sfn "$PWD/fish/config.fish" "$HOME/.config/fish/config.fish"
for file in "$PWD"/fish/conf.d/*.fish; do
  ln -sfn "$file" "$HOME/.config/fish/conf.d/$(basename "$file")"
done

for file in "$PWD"/fish/functions/*.fish; do
  [ -e "$file" ] && ln -sfn "$file" "$HOME/.config/fish/functions/$(basename "$file")"
done

for file in "$PWD"/fish/completions/*.fish; do
  [ -e "$file" ] && ln -sfn "$file" "$HOME/.config/fish/completions/$(basename "$file")"
done

ln -sfn "$PWD/git/.gitconfig" "$HOME/.gitconfig"
ln -sfn "$PWD/ghostty/config" "$HOME/.config/ghostty/config"
ln -sfn "$PWD/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$PWD/zed/settings.json" "$HOME/.config/zed/settings.json"

if ! grep -qx "$(command -v fish)" /etc/shells; then
  command -v fish | sudo tee -a /etc/shells >/dev/null
fi

if [ "$(dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}')" != "$(command -v fish)" ]; then
  chsh -s "$(command -v fish)"
fi

if [ -t 0 ] && [ "${DOTFILES_SKIP_EXEC_FISH:-}" != "1" ]; then
  exec "$(command -v fish)"
fi

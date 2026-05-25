#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

echo "🚀 セットアップ開始..."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "📦 Xcode CLT確認..."
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

echo "🍺 Homebrew確認..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file="$DOTFILES/Brewfile" --no-upgrade || true

echo "🐚 oh-my-zsh確認..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "🔌 oh-my-zshプラグイン確認..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    dir="$ZSH_CUSTOM/plugins/$plugin"
    if [ ! -d "$dir" ]; then
        git clone "https://github.com/zsh-users/$plugin" "$dir" || true
    fi
done

echo "🔗 シンボリックリンク作成..."
backup_if_real_path() {
    local target="$1"
    if [ -L "$target" ] || [ ! -e "$target" ]; then
        return
    fi
    mv "$target" "${target}.bak"
}

backup_if_real_path ~/.zshrc
backup_if_real_path ~/.zprofile
backup_if_real_path ~/.gitconfig
backup_if_real_path ~/.tmux.conf
backup_if_real_path ~/.config/ghostty
backup_if_real_path ~/.config/nvim
backup_if_real_path ~/.claude/CLAUDE.md
backup_if_real_path ~/.codex/AGENTS.md

cd "$DOTFILES"

stow -R zsh git ghostty tmux nvim

echo "🤖 Claude Code設定..."
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "🤖 Codex設定..."
mkdir -p "$HOME/.codex"
ln -sf "$DOTFILES/claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"

echo "✅ セットアップ完了！"
echo "👉 ターミナル再起動して！"

#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREW_BIN="/opt/homebrew/bin/brew"

LINKS=(
    "$DOTFILES/zsh/.zshrc:$HOME/.zshrc"
    "$DOTFILES/zsh/.zprofile:$HOME/.zprofile"
    "$DOTFILES/git/.gitconfig:$HOME/.gitconfig"
    "$DOTFILES/ghostty/config:$HOME/.config/ghostty/config"
    "$DOTFILES/starship/starship.toml:$HOME/.config/starship.toml"
    "$DOTFILES/zed/settings.json:$HOME/.config/zed/settings.json"
    "$DOTFILES/claude/CLAUDE.md:$HOME/.claude/CLAUDE.md"
    "$DOTFILES/claude/CLAUDE.md:$HOME/.codex/AGENTS.md"
)

backup_path() {
    local target="$1"
    local backup="${target}.bak"
    local index=1

    if [ ! -e "$backup" ] && [ ! -L "$backup" ]; then
        echo "$backup"
        return
    fi

    while [ -e "${backup}.${index}" ] || [ -L "${backup}.${index}" ]; do
        index=$((index + 1))
    done

    echo "${backup}.${index}"
}

link_file() {
    local src="$1"
    local target="$2"

    if [ ! -e "$src" ]; then
        echo "❌ リンク元がありません: $src" >&2
        exit 1
    fi

    mkdir -p "$(dirname "$target")"

    if [ -L "$target" ]; then
        if [ "$(readlink "$target")" = "$src" ]; then
            echo "  ok: $target"
            return
        fi
        unlink "$target"
    elif [ -e "$target" ]; then
        local backup
        backup="$(backup_path "$target")"
        mv "$target" "$backup"
        echo "  backup: $target -> $backup"
    fi

    ln -s "$src" "$target"
    echo "  link: $target -> $src"
}

echo "🚀 セットアップ開始..."

echo "📦 Xcode CLT確認..."
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

echo "🍺 Homebrew確認..."
if [ ! -x "$BREW_BIN" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x "$BREW_BIN" ]; then
    echo "❌ Homebrew が見つかりません" >&2
    exit 1
fi

eval "$("$BREW_BIN" shellenv)"
"$BREW_BIN" bundle --file="$DOTFILES/Brewfile" --no-upgrade

echo "🔐 zsh補完ディレクトリ権限確認..."
if [ -d "$HOMEBREW_PREFIX/share" ] && [ -w "$HOMEBREW_PREFIX/share" ]; then
    chmod g-w "$HOMEBREW_PREFIX/share"
fi

echo "🔗 シンボリックリンク作成..."
for pair in "${LINKS[@]}"; do
    src="${pair%%:*}"
    target="${pair#*:}"
    link_file "$src" "$target"
done

echo "✅ セットアップ完了！"
echo "👉 ターミナル再起動して！"

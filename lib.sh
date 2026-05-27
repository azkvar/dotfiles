#!/bin/bash
# install.sh / link.sh / unlink.sh が共有する設定と関数。
# 単体実行用ではなく source して使う。

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

LINKS=(
    "$DOTFILES/zsh/.zshrc:$HOME/.zshrc"
    "$DOTFILES/zsh/.zprofile:$HOME/.zprofile"
    "$DOTFILES/git/.gitconfig:$HOME/.gitconfig"
    "$DOTFILES/tmux/.tmux.conf:$HOME/.tmux.conf"
    "$DOTFILES/ghostty/config:$HOME/.config/ghostty/config"
    "$DOTFILES/starship/starship.toml:$HOME/.config/starship.toml"
    "$DOTFILES/zed/settings.json:$HOME/.config/zed/settings.json"
    "$DOTFILES/vscode/settings.json:$HOME/Library/Application Support/Code/User/settings.json"
    "$DOTFILES/claude/CLAUDE.md:$HOME/.claude/CLAUDE.md"
    "$DOTFILES/claude/CLAUDE.md:$HOME/.codex/AGENTS.md"
)

# link 時に既存の実ファイルがあれば退避する対象
BACKUP_TARGETS=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.gitconfig"
    "$HOME/.tmux.conf"
    "$HOME/.config/ghostty/config"
    "$HOME/.config/starship.toml"
    "$HOME/.config/zed/settings.json"
    "$HOME/Library/Application Support/Code/User/settings.json"
    "$HOME/.claude/CLAUDE.md"
    "$HOME/.codex/AGENTS.md"
)

# シンボリックリンクでない実体ファイルだけ .bak に退避する
backup_if_real_path() {
    local target="$1"
    if [ -L "$target" ] || [ ! -e "$target" ]; then
        return
    fi
    mv "$target" "${target}.bak"
}

link_file() {
    local source="$1"
    local target="$2"
    mkdir -p "$(dirname "$target")"
    if [ -L "$target" ]; then
        unlink "$target"
    fi
    ln -s "$source" "$target"
}

unlink_file() {
    local target="$1"
    if [ -L "$target" ]; then
        unlink "$target"
    fi
}

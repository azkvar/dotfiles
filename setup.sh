#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"

echo "🚀 セットアップ開始..."

echo "📦 Xcode CLT確認..."
xcode-select --install 2>/dev/null || true

echo "🍺 Homebrew確認..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
fi
brew bundle --file="$DOTFILES/Brewfile"

echo "🐚 oh-my-zsh確認..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "🔌 oh-my-zshプラグイン確認..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
    $ZSH_CUSTOM/plugins/zsh-autosuggestions

[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && \
    git clone https://github.com/zsh-users/zsh-completions \
    $ZSH_CUSTOM/plugins/zsh-completions

echo "🦀 Rust確認..."
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"

echo "🦀 Cargoツールインストール..."
cargo install cargo-nextest --locked 2>/dev/null || true
cargo install cargo-flamegraph 2>/dev/null || true
cargo install cargo-criterion 2>/dev/null || true
cargo install bacon --locked 2>/dev/null || true
cargo install cargo-expand 2>/dev/null || true

echo "🤖 Claude Code確認..."
if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

echo "🔧 mise言語インストール..."
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"
mise install

echo "🔗 シンボリックリンク作成..."
cd "$DOTFILES"
[ -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc"
[ -L "$HOME/.gitconfig" ] && rm "$HOME/.gitconfig"
[ -L "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf"
[ -L "$HOME/.ssh/config" ] && rm "$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

stow -R zsh git mise ghostty tmux ssh

chmod 600 "$HOME/.ssh/config"

echo "💻 VSCode設定..."
mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$DOTFILES/vscode/settings.json" \
    "$HOME/Library/Application Support/Code/User/settings.json"

echo "🔌 VSCode拡張機能インストール..."
if command -v code &>/dev/null; then
  cat "$DOTFILES/vscode/extensions.txt" | xargs -I {} code --install-extension {}
fi

echo "✅ セットアップ完了！"
echo "👉 ターミナル再起動してな！"

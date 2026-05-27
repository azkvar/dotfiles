#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

echo "🔗 シンボリックリンク作成..."

for target in "${BACKUP_TARGETS[@]}"; do
    backup_if_real_path "$target"
done

for pair in "${LINKS[@]}"; do
    source="${pair%%:*}"
    target="${pair#*:}"
    link_file "$source" "$target"
done

echo "✅ リンク完了！"

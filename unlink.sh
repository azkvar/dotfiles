#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

echo "🧹 シンボリックリンク削除..."

for pair in "${LINKS[@]}"; do
    target="${pair#*:}"
    unlink_file "$target"
done

echo "✅ リンク削除完了！"

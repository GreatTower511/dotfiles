#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

LINKS=(
  ".config/nvim"
  ".config/wezterm"
  ".config/starship.toml"
)

create_symlink() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  if [ ! -e "$src" ]; then
    echo "  [SKIP] $src が見つかりません"
    return
  fi

  mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    echo "  [OK]   $dest (既にシンボリックリンク)"
    return
  fi

  if [ -e "$dest" ]; then
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    echo "  [BACKUP] $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  echo "  [LINK] $src -> $dest"
}

echo "=== dotfiles setup ==="
echo ""

for link in "${LINKS[@]}"; do
  create_symlink "$link"
done

echo ""
echo "=== 依存ツールの確認 ==="

check_command() {
  if command -v "$1" &>/dev/null; then
    echo "  [OK]   $1"
  else
    echo "  [MISSING] $1 がインストールされていません"
  fi
}

check_command nvim
check_command wezterm
check_command starship

echo ""
echo "セットアップ完了!"

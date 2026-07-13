#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"

LINKS=(
  ".config/nvim"
  ".config/wezterm"
  ".config/starship.toml"
  ".serena/serena_config.yml"
)

BIN_DIR="$DOTFILES_DIR/bin"
GIT_DELTA_CONFIG="$DOTFILES_DIR/git/delta.gitconfig"

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

# --- greview: bin/ を PATH に追加 ---
echo ""
echo "=== bin/ スクリプトのセットアップ ==="

if [ -d "$BIN_DIR" ]; then
  chmod +x "$BIN_DIR"/*
  echo "  [OK]   $BIN_DIR のスクリプトに実行権限を付与"
  if ! grep -q 'dotfiles/bin' "$HOME/.zshrc" 2>/dev/null; then
    echo "" >> "$HOME/.zshrc"
    echo "# dotfiles bin" >> "$HOME/.zshrc"
    echo 'export PATH="$HOME/dotfiles/bin:$PATH"' >> "$HOME/.zshrc"
    echo "  [ADDED] dotfiles/bin を PATH に追加 (~/.zshrc)"
  else
    echo "  [OK]   dotfiles/bin は既にPATHに追加済み"
  fi
fi

# --- git delta 設定のinclude追加 ---
echo ""
echo "=== git delta 設定 ==="

if [ -f "$GIT_DELTA_CONFIG" ]; then
  if ! git config --global --get-all include.path | grep -q "dotfiles/git/delta.gitconfig" 2>/dev/null; then
    git config --global --add include.path "$GIT_DELTA_CONFIG"
    echo "  [ADDED] ~/.gitconfig に delta設定をinclude"
  else
    echo "  [OK]   delta設定は既にinclude済み"
  fi
fi

echo ""
echo "=== 依存ツールの確認 ==="

check_command() {
  local name="$1"
  local app_name="${2:-}"

  if command -v "$name" &>/dev/null; then
    echo "  [OK]   $name"
    return
  fi

  if [ -n "$app_name" ]; then
    local app_path
    app_path="$(mdfind "kMDItemDisplayName == '$app_name'" 2>/dev/null | head -n 1)"
    if [ -n "$app_path" ]; then
      echo "  [OK]   $name ($app_path)"
      return
    fi
  fi

  echo "  [MISSING] $name がインストールされていません"
}

check_command nvim
check_command wezterm "WezTerm"
check_command starship
check_command delta "git-delta (brew install git-delta)"
check_command fzf "fzf (brew install fzf)"

echo ""
echo "セットアップ完了!"

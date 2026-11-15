#!/bin/bash
# 設定ファイルのリンクと Claude Code の設定を行う。何度実行しても同じ結果になる。
# ツールのインストールまで含めた一括セットアップは install.sh を使う。
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# $HOME からの相対パス。dotfiles 内の同じパスへリンクする。
LINKS=(
  ".zshrc"
  ".config/nvim"
  ".config/ghostty"
  ".config/cmux/cmux.json"
  ".config/starship.toml"
  ".serena/serena_config.yml"
  ".claude/settings.json"
  ".claude/CLAUDE.md"
)

BIN_DIR="$DOTFILES_DIR/bin"
GIT_DELTA_CONFIG="$DOTFILES_DIR/git/delta.gitconfig"

create_symlink() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"

  if [ ! -e "$src" ]; then
    echo "  [SKIP] $src が見つかりません"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  [OK]   $dest"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="${dest}.backup.$(date +%Y%m%d%H%M%S)"
    echo "  [BACKUP] $dest -> $backup"
    mv "$dest" "$backup"
  fi

  ln -s "$src" "$dest"
  echo "  [LINK] $dest -> $src"
}

echo "=== 設定ファイルのリンク ==="
for link in "${LINKS[@]}"; do
  create_symlink "$link"
done

if [ ! -f "$HOME/.zshrc.local" ]; then
  cat > "$HOME/.zshrc.local" <<'EOF'
# PC 固有・仕事用の設定 (Git 管理外)。~/.zshrc の最後で読み込まれる。
EOF
  echo "  [NEW]  ~/.zshrc.local を作成 (仕事用のエイリアスなどはここに書く)"
fi

echo ""
echo "=== bin/ スクリプト ==="
if [ -d "$BIN_DIR" ]; then
  chmod +x "$BIN_DIR"/*
  echo "  [OK]   $BIN_DIR に実行権限を付与 (PATH は .zshrc で追加)"
fi

echo ""
echo "=== git delta 設定 ==="
if [ -f "$GIT_DELTA_CONFIG" ]; then
  if git config --global --get-all include.path 2>/dev/null | grep -q "dotfiles/git/delta.gitconfig"; then
    echo "  [OK]   delta 設定は include 済み"
  else
    git config --global --add include.path "$GIT_DELTA_CONFIG"
    echo "  [ADDED] ~/.gitconfig に delta 設定を include"
  fi
fi

echo ""
echo "=== Claude Code ==="
if command -v claude &>/dev/null; then
  if claude mcp get serena &>/dev/null; then
    echo "  [OK]   Serena MCP は登録済み"
  elif command -v uvx &>/dev/null; then
    claude mcp add --scope user serena -- \
      uvx --from git+https://github.com/oraios/serena \
      serena start-mcp-server --context claude-code --project-from-cwd
    echo "  [ADDED] Serena MCP を登録 (user スコープ)"
  else
    echo "  [SKIP] uvx が無いため Serena MCP を登録できません (brew install uv)"
  fi
else
  echo "  [SKIP] claude が無いため MCP の登録を飛ばしました"
fi

if [ ! -x "$HOME/.claude/hooks/guard-secrets-and-apply.sh" ]; then
  echo "  [INFO] ~/.claude/hooks/guard-secrets-and-apply.sh が無いため、秘密情報ガードの hook は何もしません"
fi

echo ""
echo "=== 依存ツールの確認 ==="
check_command() {
  if command -v "$1" &>/dev/null; then
    echo "  [OK]   $1"
  elif [ -n "${2:-}" ] && [ -d "$2" ]; then
    echo "  [OK]   $1 ($2)"
  else
    echo "  [MISSING] $1"
  fi
}

check_command nvim
check_command cmux "/Applications/cmux.app"
check_command starship
check_command delta
check_command fzf
check_command jq
check_command uv
check_command gh
check_command claude

echo ""
echo "セットアップ完了! 新しいシェルを開くと .zshrc が反映されます。"

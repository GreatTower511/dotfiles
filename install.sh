#!/bin/bash
# 新しい Mac を 1 コマンドで環境構築する。
#
#   curl -fsSL https://raw.githubusercontent.com/GreatTower511/dotfiles/main/install.sh | bash
#
# 何度実行しても同じ結果になる。
set -euo pipefail

REPO_URL="https://github.com/GreatTower511/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

step() { echo ""; echo "=== $1 ==="; }

# --- Xcode Command Line Tools (git に必要) ---
step "Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
  xcode-select --install || true
  echo "インストールのダイアログが開きました。完了したらもう一度このコマンドを実行してください。"
  exit 1
fi
echo "  [OK]"

# --- Homebrew ---
step "Homebrew"
if [ ! -x /opt/homebrew/bin/brew ] && ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
echo "  [OK] $(brew --version | head -n 1)"

# --- dotfiles の取得 ---
step "dotfiles"
if [ -d "$DOTFILES_DIR/.git" ]; then
  git -C "$DOTFILES_DIR" pull --ff-only || echo "  [WARN] pull できませんでした。手元の状態のまま進めます"
else
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# --- パッケージ ---
step "brew bundle"
brew bundle --file "$DOTFILES_DIR/Brewfile"

# --- Claude Code (ネイティブ版) ---
step "Claude Code"
if command -v claude &>/dev/null || [ -x "$HOME/.local/bin/claude" ]; then
  echo "  [OK] インストール済み"
else
  curl -fsSL https://claude.ai/install.sh | bash
fi
export PATH="$HOME/.local/bin:$PATH"

# --- 設定ファイルのリンク・MCP の登録 ---
step "setup.sh"
"$DOTFILES_DIR/setup.sh"

cat <<'EOF'

=== 残りは手で行うもの ===
  1. 新しいターミナル (cmux) を開く
  2. claude を起動してログインする
  3. gh auth login
  4. 仕事用の設定を入れる
     - ~/.zshrc.local       … 仕事用のエイリアスなど
     - ~/.claude/hooks/     … guard-secrets-and-apply.sh などの hook
     - ~/.claude/skills, ~/.claude/agents
EOF

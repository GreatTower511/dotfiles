# dotfiles

個人用の設定ファイル管理レポジトリ（macOS / cmux + Claude Code）。

> このレポジトリは公開です。仕事用の設定や秘密情報は入れず、`~/.zshrc.local` や `~/.claude/hooks/` など Git 管理外の場所に置きます。

## 新しい Mac のセットアップ（1 コマンド）

```bash
curl -fsSL https://raw.githubusercontent.com/GreatTower511/dotfiles/main/install.sh | bash
```

`install.sh` が行うこと:

1. Xcode Command Line Tools の確認（無ければインストールを開始して終了 → 完了後にもう一度実行）
2. Homebrew のインストール
3. このレポジトリを `~/dotfiles` に clone（既にあれば pull）
4. `brew bundle` で `Brewfile` のツールを入れる（cmux・neovim・starship・delta・gh・jq・uv など）
5. Claude Code（ネイティブ版）のインストール
6. `setup.sh` の実行

最後に、手で行うもの（Claude へのログイン、`gh auth login`、仕事用の設定）が表示されます。

## 設定だけ反映する

```bash
~/dotfiles/setup.sh
```

- 下の表のファイルを `$HOME` 側からシンボリックリンクする（既存のファイルは `*.backup.<日時>` に退避）
- `~/.zshrc.local` が無ければ空で作る
- `~/.gitconfig` に `git/delta.gitconfig` を include する
- Claude Code に Serena MCP を user スコープで登録する

## 含まれる設定

| ツール | dotfiles | リンク先 |
|---|---|---|
| zsh | `.zshrc` | `~/.zshrc` |
| cmux | `.config/cmux/cmux.json` | `~/.config/cmux/cmux.json` |
| cmux のターミナル (Ghostty) | `.config/ghostty/` | `~/.config/ghostty/` |
| Neovim | `.config/nvim/` | `~/.config/nvim/` |
| Starship | `.config/starship.toml` | `~/.config/starship.toml` |
| Serena | `.serena/serena_config.yml` | `~/.serena/serena_config.yml` |
| Claude Code | `.claude/settings.json`, `.claude/CLAUDE.md` | `~/.claude/` |
| git delta | `git/delta.gitconfig` | `~/.gitconfig` から include |
| スクリプト | `bin/` | `.zshrc` で PATH に追加 |

## Claude Code の hook

`settings.json` の hook は、次のファイルがあれば実行し、無ければ何もしません。中身は PC ごとに置きます。

- `~/.claude/hooks/guard-secrets-and-apply.sh` … PreToolUse（秘密情報・terraform apply などのガード）
- `~/.claude/hooks/user-prompt-submit.local.sh` … UserPromptSubmit

# dotfiles

個人用の設定ファイル管理リポジトリ。

## 含まれる設定

| ツール | パス |
|---|---|
| Neovim | `.config/nvim/` |
| cmux (Ghostty) | `.config/ghostty/` |
| Starship | `.config/starship.toml` |
| Serena MCP | `.serena/serena_config.yml` → `~/.serena/serena_config.yml` |

## セットアップ

```bash
git clone git@github.com:<USERNAME>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` は以下を行います:

1. 既存の設定ファイルがあればバックアップ（`*.backup.<timestamp>`）
2. `~/dotfiles/.config/*` から `~/.config/*` へシンボリックリンクを作成
3. 必要なツール（nvim, cmux, starship）のインストール確認

## 前提ツール

- [Neovim](https://neovim.io/)
- [cmux](https://github.com/manaflow-ai/cmux) — `brew tap manaflow-ai/cmux && brew install --cask cmux`
- [Starship](https://starship.rs/)

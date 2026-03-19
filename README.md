# dotfiles

個人用の設定ファイル管理リポジトリ。

## 含まれる設定

| ツール | パス |
|---|---|
| Neovim | `.config/nvim/` |
| WezTerm | `.config/wezterm/` |
| Starship | `.config/starship.toml` |

## セットアップ

```bash
git clone git@github.com:<USERNAME>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

`setup.sh` は以下を行います:

1. 既存の設定ファイルがあればバックアップ（`*.backup.<timestamp>`）
2. `~/dotfiles/.config/*` から `~/.config/*` へシンボリックリンクを作成
3. 必要なツール（nvim, wezterm, starship）のインストール確認

## 前提ツール

- [Neovim](https://neovim.io/)
- [WezTerm](https://wezfurlong.org/wezterm/)
- [Starship](https://starship.rs/)

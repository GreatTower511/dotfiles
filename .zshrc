# ~/dotfiles/.zshrc  (~/.zshrc からシンボリックリンク)
# このレポジトリは公開。仕事用のエイリアスや PC 固有の設定は ~/.zshrc.local に書く (Git 管理外)。

# --- Homebrew ---
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# --- プロンプト ---
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- エイリアス ---
alias dc='docker-compose'
alias gst='git status'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gdh='git diff HEAD'
alias cl='claude'
alias tf='terraform'

# --- 言語のバージョン管理 (入っているものだけ) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if command -v goenv >/dev/null || [ -d "$HOME/.goenv/bin" ]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

[ -d "$HOME/.rvm/bin" ] && export PATH="$PATH:$HOME/.rvm/bin"

if command -v pyenv >/dev/null || [ -d "$HOME/.pyenv/bin" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# --- ssh を gpg-agent 経由で使う ---
if command -v gpgconf >/dev/null; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi

# --- その他のツール (入っていれば) ---
[ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# --- PATH: Claude Code のネイティブ版と dotfiles/bin を最優先に ---
export PATH="$HOME/.local/bin:$HOME/dotfiles/bin:$PATH"

# --- PC 固有・仕事用の設定 (Git 管理外) ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

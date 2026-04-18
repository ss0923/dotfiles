export EDITOR='nvim'
export VISUAL='nvim'
export LESSHISTFILE=-
export LESS="-R --mouse"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# language tool xdg redirects — old ~/.<tool> dirs become dormant after
# these take effect. delete them when convenient with disk pressure.
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle/config"
export BUNDLE_USER_HOME="$XDG_DATA_HOME/bundle"
export GHCUP_USE_XDG_DIRS=1
export PUB_CACHE="$XDG_DATA_HOME/pub-cache"
export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"
export GOBIN="$HOME/.local/bin"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_DATA_HOME/go/pkg/mod"

# zsh state → xdg
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
export SHELL_SESSIONS_DISABLE=1

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export PNPM_HOME="$HOME/.local/share/pnpm"

# Claude Code: pin effort level to max. Env var is authoritative (settings.json
# `effortLevel: "max"` has known persistence bugs — env var takes precedence).
export CLAUDE_CODE_EFFORT_LEVEL=max

typeset -U path
path=(
  "$HOME/.local/bin"
  "$CARGO_HOME/bin"
  "$PNPM_HOME"
  /opt/homebrew/opt/postgresql/bin
  $path
)
export PI_HARDWARE_CURSOR=1

export EDITOR='nvim'
export VISUAL='nvim'
export LESSHISTFILE=-
export LESS="-R --mouse"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

export PNPM_HOME="$HOME/.local/share/pnpm"

# Claude Code: pin effort level to max. Env var is authoritative (settings.json
# `effortLevel: "max"` has known persistence bugs — env var takes precedence).
export CLAUDE_CODE_EFFORT_LEVEL=max

typeset -U path
path=(
  "$HOME/.local/bin"
  "$HOME/go/bin"
  "$PNPM_HOME"
  /opt/homebrew/opt/postgresql/bin
  $path
)
export PI_HARDWARE_CURSOR=1

[[ -n "$ZSHRC_PROF" ]] && zmodload zsh/zprof

if [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]] && [[ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]] && [[ -t 1 ]] && command -v tmux &>/dev/null; then
  exec tmux new-session -A -s main -c "$HOME"
fi

# plugins
export FORGIT_NO_ALIASES=1
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
eval "$(sheldon source)"

AUTO_NOTIFY_THRESHOLD=30
AUTO_NOTIFY_IGNORE=("v" "vim" "nvim" "less" "more" "man" "top" "htop" "btm" "ssh" "tmux" "docker" "lazygit" "lazydocker" "yazi" "claude" "navi" "watch" "tail" "bat")

if [[ -n "$TMUX" ]] && (( $+functions[_auto_notify_message] )); then
    eval "original_$(declare -f _auto_notify_message)"
    _auto_notify_message() {
        local command="$1" elapsed="$2" exit_code="$3"
        notify-if-away "$command Completed" "Time: ${elapsed}s — exit $exit_code"
    }
fi

# completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'

[[ -d "$XDG_CACHE_HOME/zsh/zcompcache" ]] || mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --oneline --graph --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 'git log --oneline --graph --color=always $word'

# keybindings
zle_highlight+=(paste:none)
stty -ixon
WORDCHARS=${WORDCHARS//[\/]}
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

KEYTIMEOUT=1
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

function clear-screen-and-scrollback() {
  printf '\033[3J'
  STARSHIP_CMD_STATUS=0 STARSHIP_PIPE_STATUS=(0)
  zle .clear-screen
  if [[ -n "$TMUX" ]]; then
    (command tmux clear-history 2>/dev/null &) 2>/dev/null
  fi
}
zle -N clear-screen-and-scrollback
bindkey '^l' clear-screen-and-scrollback
bindkey '\e[k' clear-screen-and-scrollback

# history
HISTSIZE=50000
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
SAVEHIST=$HISTSIZE
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_verify
setopt interactive_comments
setopt no_beep

# core aliases
alias ls='eza'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza --tree --level=2'
alias cat='bat --paging=never'
alias catp='bat'
alias du='dust'
alias df='duf'
alias top='btop'
alias vim='nvim'
alias neovim='nvim'

alias v='nvim'
alias http='xh'
alias https='xh --https'
alias watch='viddy'
alias pst='procs --tree'
alias lg='lazygit'
# `clear` as a function so we can also prime _first_prompt=1 — this makes the
# next precmd take the full-redraw branch of _prompt_newline, avoiding the blank
# line that would otherwise sit above the prompt after clearing.
clear() {
  command clear
  [[ -n "$TMUX" ]] && command tmux clear-history 2>/dev/null
  _first_prompt=1
}
alias c='clear'
alias cl='clear'
alias cdc='cd ~ && clear'
alias clear-history='echo "" > "$HISTFILE" && fc -p "$HISTFILE" && echo "History cleared."'
alias src='source'

# finder
alias reveal='open -R'
alias finder='open .'

# git
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gbd='git branch -d'
alias gc='git commit'
alias gc!='git commit --amend'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gl='git log --oneline --graph'
alias glog='git log --graph --pretty=format:"%C(auto)%h%d %s %C(dim)%cr"'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gm='git merge'
alias gst='git status'
alias gss='git status -s'
alias gsta='git stash'
alias gstp='git stash pop'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gab='git absorb'
alias gdf='git dft'

# tmux
alias t='tmux'
alias ta='tmux attach-session'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'
alias tka='tmux kill-server'
alias td='tmux detach'

# chezmoi
alias cm='chezmoi'
alias cma='chezmoi apply'
alias cmad='chezmoi add'
alias cmdf='chezmoi diff'
alias cme='chezmoi edit'
alias cms='chezmoi status'
alias cmu='chezmoi update'

# just
alias j='just'
alias jl='just --list'

# pnpm
alias pn='pnpm'
alias pni='pnpm install'
alias pna='pnpm add'
alias pnad='pnpm add -D'
alias pnr='pnpm run'
alias pnrm='pnpm remove'
alias pnt='pnpm test'
alias pnx='pnpx'
alias pnd='pnpm dev'

# docker
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcr='docker compose run --rm'
alias dce='docker compose exec'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias hl='hadolint'
alias lzd='lazydocker'

# ansible
alias ans='ansible'
alias ansp='ansible-playbook'
alias ansv='ansible-vault'
alias ansg='ansible-galaxy'
alias ansl='ansible-lint'

# terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfv='terraform validate'
alias tfo='terraform output'
alias tfs='terraform state list'
alias tfw='terraform workspace'

# nix
alias nx='nix'
alias nxb='nix build'
alias nxd='nix develop'
alias nxr='nix run'
alias nxs='nix shell'
alias nxf='nix flake'
alias nxfu='nix flake update'
alias nxfc='nix flake check'

# elixir
alias m='mix'
alias mt='mix test'
alias mc='mix compile'
alias mps='mix phx.server'
alias ism='iex -S mix'
alias ismp='iex -S mix phx.server'
alias mdg='mix deps.get'
alias mdc='mix deps.compile'
alias mer='mix ecto.reset'
alias mem='mix ecto.migrate'
alias meg='mix ecto.gen.migration'

# erlang
alias rb3='rebar3'
alias rb3c='rebar3 compile'
alias rb3t='rebar3 eunit'
alias rb3ct='rebar3 ct'
alias rb3r='rebar3 release'
alias rb3s='rebar3 shell'

# rust
alias cg='cargo'
alias cgr='cargo run'
alias cgb='cargo build'
alias cgt='cargo test'
alias cgc='cargo check'
alias cgcl='cargo clippy'

# go
alias got='go test ./...'
alias gor='go run .'
alias gob='go build'
alias gomt='go mod tidy'

# python
alias py='python'
alias pt='pytest'
alias ptv='pytest -v'
alias pti='pip install'

# ruby
alias be='bundle exec'
alias bl='bundle'
alias bli='bundle install'
alias rk='rake'

# haskell
alias st='stack'
alias stb='stack build'
alias stt='stack test'
alias str='stack run'
alias stg='stack ghci'
alias cb='cabal'
alias cbb='cabal build'
alias cbt='cabal test'
alias cbr='cabal run'

# ocaml
alias op='opam'
alias opi='opam install'
alias ops='opam switch'
alias dn='dune'
alias dnb='dune build'
alias dnt='dune test'
alias dnr='dune exec'

# deno
alias de='deno'
alias der='deno run'
alias det='deno test'
alias def='deno fmt'
alias dec='deno check'
alias del='deno lint'

# dotnet
alias dot='dotnet'
alias dotr='dotnet run'
alias dotb='dotnet build'
alias dott='dotnet test'
alias dotw='dotnet watch'
alias dotn='dotnet new'
alias dota='dotnet add'

# clojure
alias clj='clojure'
alias cljr='clojure -M:repl'
alias leinr='lein repl'
alias leint='lein test'
alias leinb='lein uberjar'

# php
alias comp='composer'
alias compi='composer install'
alias compu='composer update'
alias compr='composer require'
alias comprd='composer require --dev'
alias compa='composer dump-autoload'
alias art='php artisan'
alias arts='php artisan serve'
alias artm='php artisan migrate'
alias artmr='php artisan migrate:rollback'
alias pu='./vendor/bin/phpunit'
alias put='./vendor/bin/phpunit --filter'

# scala
alias sbtc='sbt compile'
alias sbtt='sbt test'
alias sbtr='sbt run'
alias sbtcl='sbt clean'
alias sc='scala'

# swift
alias swb='swift build'
alias swr='swift run'
alias swt='swift test'
alias swp='swift package'

# gleam
alias ge='gleam'
alias ger='gleam run'
alias geb='gleam build'
alias get='gleam test'
alias gea='gleam add'
alias gen='gleam new'

# dart/flutter
alias fl='flutter'
alias flr='flutter run'
alias flt='flutter test'
alias flb='flutter build'
alias flc='flutter clean'
alias flpg='flutter pub get'
alias flpa='flutter pub add'
alias flpad='flutter pub add --dev'
alias fld='flutter devices'
alias fle='flutter emulators'
alias fla='flutter analyze'
alias flcr='flutter create'
alias dt='dart'
alias dtr='dart run'
alias dtt='dart test'
alias dtf='dart fix --apply'
alias dta='dart analyze'

# kotlin
alias kt='kotlin'
alias ktc='kotlinc'
alias ktg='./gradlew'
alias ktgb='./gradlew build'
alias ktgt='./gradlew test'
alias ktgr='./gradlew run'

# lua
alias lr='luarocks'
alias lri='luarocks install'
alias lrs='luarocks search'

# zig
alias zb='zig build'
alias zt='zig test'
alias zr='zig run'

# r
alias rr='Rscript'
alias rir='Rscript -e "install.packages(commandArgs(TRUE))" --args'

# julia
alias jul='julia'

# foundry
alias fo='forge'
alias fob='forge build'
alias fot='forge test'
alias fof='forge fmt'

# buf
alias bf='buf'
alias bfl='buf lint'
alias bfg='buf generate'
alias bff='buf format -w'

# helm
alias hm='helm'
alias hmi='helm install'
alias hmu='helm upgrade'
alias hml='helm list'
alias hmt='helm template'

# shell
alias shf='shfmt'
alias shc='shellcheck'

# latex
alias lmk='latexmk'
alias lmkc='latexmk -c'

# yt-dlp
alias yt='yt-dlp'
alias yta='yt-dlp -x --audio-format mp3 --audio-quality 0'
alias ytv='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]"'

# functions
mkcd() { mkdir -p "$1" && cd "$1" }
killport() {
  local pids="$(lsof -ti:"$1" 2>/dev/null)"
  if [[ -z "$pids" ]]; then
    echo "No process on port $1"
    return 1
  fi
  echo "$pids" | xargs kill 2>/dev/null
  sleep 1
  lsof -ti:"$1" 2>/dev/null | xargs kill -9 2>/dev/null
  echo "Killed processes on port $1"
}

y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

ginit() {
  local version=${1:-"0.1.0"}
  [ ! -d .git ] && git init
  if [ -f package.json ]; then
    sd '"version": "[^"]*"' "\"version\": \"$version\"" package.json
  fi
  git add --all
  gcm "feat: init" -m "Release-As: $version"
  echo "Initialized with version $version"
}

gh-clear-runs() {
  if [ -z "$1" ]; then
    echo "Usage: gh-clear-runs <owner/repo>"
    return 1
  fi
  local repo="$1"
  echo "Fetching workflow runs for $repo..."
  local run_ids=$(gh api "repos/$repo/actions/runs" --paginate -q '.workflow_runs[].id')
  local count=$(echo "$run_ids" | wc -l)
  count=${count// /}
  if [ "$count" -eq 0 ]; then
    echo "No workflow runs found."
    return 0
  fi
  echo "Found $count workflow run(s) to delete."
  read "confirm?Delete all $count runs? (y/N) "
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "Deleting runs..."
    local deleted=0
    while read -r run_id; do
      if gh api "repos/$repo/actions/runs/$run_id" -X DELETE >/dev/null 2>&1; then
        ((deleted++))
        echo "[$deleted/$count] Deleted run $run_id"
      else
        echo "Failed to delete run $run_id"
      fi
    done <<< "$run_ids"
    echo "Done!"
  else
    echo "Cancelled."
  fi
}

gclone() { git clone "$1" && cd "$(basename "$1" .git)" }

bman() {
  local f=$(man -w "$@" 2>/dev/null)
  [[ -z "$f" ]] && echo "No man page: $*" >&2 && return 1
  local style="$XDG_CONFIG_HOME/bman/style.css"
  local name=${@[-1]}
  local sect=""
  (( $# > 1 )) && sect=$1
  local out="${TMPDIR:-/tmp}/man-${name}${sect:+.$sect}.html"
  local xr_sed='s|<a class="Xr">([a-zA-Z0-9._+-]+)\(([0-9][a-z]*)\)</a>|<a class="Xr" href="file://${TMPDIR:-/tmp}/man-\1.\2.html">\1(\2)</a>|g'
  mandoc -T html -O style="$style" "$f" | sed -E "$xr_sed" > "$out"
  open "$out"
  (
    local refs=(${(f)"$(grep -oE 'man-[^"]+\.html' "$out" | sed 's|man-||;s|\.html||' | sort -u)"})
    for ref in $refs; do
      [[ -f "${TMPDIR:-/tmp}/man-${ref}.html" ]] && continue
      local rname=${ref%%.*} rsect=${ref#*.}
      local rsrc=$(man -w "$rsect" "$rname" 2>/dev/null)
      [[ -z "$rsrc" ]] && continue
      mandoc -T html -O style="$style" "$rsrc" | sed -E "$xr_sed" > "${TMPDIR:-/tmp}/man-${ref}.html" &
    done
    wait
  ) &>/dev/null
}

bmd() {
  [[ -z "$1" || ! -f "$1" ]] && echo "Usage: bmd <file.md>" >&2 && return 1
  local style="$XDG_CONFIG_HOME/bmd/style.css"
  local name=$(basename "$1" .md)
  local out="${TMPDIR:-/tmp}/md-${name}.html"
  printf '<!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>%s</title><link rel="stylesheet" href="%s"></head><body>\n' "$name" "$style" > "$out"
  cmark-gfm -e table -e autolink -e strikethrough -e tasklist "$1" >> "$out"
  printf '</body></html>\n' >> "$out"
  open "$out"
}

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
# vesper
export FZF_DEFAULT_OPTS=" \
  --color=fg:#ffffff,bg:-1,hl:#ffc799 \
  --color=fg+:#ffffff,bg+:#232323,hl+:#ffc799 \
  --color=info:#a0a0a0,prompt:#99ffe4,pointer:#ffc799 \
  --color=marker:#99ffe4,spinner:#ffc799,header:#505050 \
  --color=border:#282828,gutter:-1"
# mono
# export FZF_DEFAULT_OPTS=" \
#   --color=fg:#ffffff,bg:-1,hl:#EBEBEB \
#   --color=fg+:#ffffff,bg+:#232323,hl+:#EBEBEB \
#   --color=info:#a0a0a0,prompt:#a0a0a0,pointer:#EBEBEB \
#   --color=marker:#a0a0a0,spinner:#EBEBEB,header:#505050 \
#   --color=border:#282828,gutter:-1"
export FZF_CTRL_T_COMMAND="fd --type f --type d --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
export FZF_CTRL_R_OPTS="--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons --level=2 {}'"

# tool init
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
command -v opam >/dev/null 2>&1 && eval "$(opam env)"
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"
eval "$(mise activate zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# prompt hooks
_cmd_ran=0
_preexec_newline() { _cmd_ran=1; print }
preexec_functions=(${preexec_functions:#_preexec_newline})
preexec_functions=(_preexec_newline $preexec_functions)

_first_prompt=1
_prompt_newline() {
  if [[ -n "$_first_prompt" ]]; then
    unset _first_prompt
    printf '\e[H\e[2J\e[3J'
    [[ -n "$TMUX" ]] && command tmux clear-history 2>/dev/null
  elif (( _cmd_ran )); then
    _cmd_ran=0
    print
  fi
}
_reset_cursor() { printf '\e[3 q' }
precmd_functions=(${precmd_functions:#_prompt_newline})
precmd_functions=(${precmd_functions:#_reset_cursor})
precmd_functions=(_prompt_newline _reset_cursor $precmd_functions)

eval "$(navi widget zsh)"
bindkey '^y' _navi_widget

# env
export HOMEBREW_NO_ENV_HINTS=1

# gpg
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent 2>/dev/null

# flutter
export PATH="$HOME/fvm/default/bin:$PATH"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -f "$ZDOTDIR/.zshrc.private" ]] && source "$ZDOTDIR/.zshrc.private"

[[ -f "$ZDOTDIR/.zshrc.local" ]] && source "$ZDOTDIR/.zshrc.local"

[[ -n "$ZSHRC_PROF" ]] && zprof || true

export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"

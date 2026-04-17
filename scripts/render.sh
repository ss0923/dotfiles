#!/bin/bash
# render.sh — regenerate the public showcase from the private chezmoi sources.
#
# Runs idempotently from either machine (work or personal). Wipes and rebuilds
# both personal/ and work/ subtrees from scratch every time, so deletions in
# the templates flow through cleanly.
#
# Do NOT edit files under personal/ or work/ directly — they are generated and
# will be overwritten on the next render.

set -euo pipefail

PUB_ROOT="${PUB_ROOT:-$HOME/dev/other/dotfiles}"
CHEZMOI_SRC="$HOME/.local/share/chezmoi"

render_variant() {
  local variant="$1"
  local is_personal="$2"
  local out="$PUB_ROOT/$variant"
  local stage state
  stage="$(mktemp -d -t "chezmoi-render-${variant}.XXXXXX")"
  state="$(mktemp -t "chezmoi-state-${variant}.XXXXXX")"
  # shellcheck disable=SC2064
  trap "rm -rf '$stage' '$state'" RETURN

  echo "==> rendering $variant variant"

  chezmoi apply \
    --force \
    --exclude=scripts,encrypted,externals \
    --destination="$stage" \
    --persistent-state="$state" \
    --override-data "{\"personal\": $is_personal, \"public\": true}"

  rm -rf "$out"
  mkdir -p "$out"

  # --- allowlist: what appears in the public showcase ---
  # Copy whole subdirs from staging (~/.config/*) into tool-named folders.
  cp -r "$stage/.config/aerospace"   "$out/aerospace"
  cp -r "$stage/.config/bat"         "$out/bat"
  cp -r "$stage/.config/btop"        "$out/btop"
  cp -r "$stage/.config/fastfetch"   "$out/fastfetch"
  [ -d "$stage/.config/fd"       ] && cp -r "$stage/.config/fd"       "$out/fd"
  cp -r "$stage/.config/ghostty"     "$out/ghostty"
  cp -r "$stage/.config/homebrew"    "$out/homebrew"
  cp -r "$stage/.config/karabiner"   "$out/karabiner"
  cp -r "$stage/.config/lazygit"     "$out/lazygit"
  cp -r "$stage/.config/mise"        "$out/mise"
  cp -r "$stage/.config/navi"        "$out/navi"
  cp -r "$stage/.config/nvim"        "$out/nvim"
  cp -r "$stage/.config/ripgrep"     "$out/ripgrep"
  cp -r "$stage/.config/sheldon"     "$out/sheldon"
  [ -d "$stage/.config/starship" ] && cp -r "$stage/.config/starship" "$out/starship"
  cp -r "$stage/.config/tmux"        "$out/tmux"
  cp -r "$stage/.config/yazi"        "$out/yazi"
  cp -r "$stage/.config/yt-dlp"      "$out/yt-dlp"

  # zsh shell (files live at HOME root, regroup under zsh/)
  mkdir -p "$out/zsh"
  cp "$stage/.zshrc"    "$out/zsh/.zshrc"
  cp "$stage/.zshenv"   "$out/zsh/.zshenv"
  cp "$stage/.zprofile" "$out/zsh/.zprofile"

  # git config — sanitize absolute gh path so the public file isn't machine-specific
  mkdir -p "$out/git"
  sed 's|!.*/bin/gh|!gh|g' "$stage/.config/git/config" > "$out/git/config"

  # navi config — sanitize $HOME → ~
  sed "s|$HOME|~|g" "$stage/.config/navi/config.yaml" > "$out/navi/config.yaml"

  # mise settings — sanitize $HOME → ~ (template renders absolute homeDir)
  if [ -f "$out/mise/settings.toml" ]; then
    sed -i '' "s|$HOME|~|g" "$out/mise/settings.toml"
  fi

  # macOS defaults (from chezmoiscripts — scripts were excluded, so copy raw)
  mkdir -p "$out/macos"
  cp "$CHEZMOI_SRC/home/.chezmoiscripts/darwin/run_onchange_after_08-macos-defaults.sh" \
     "$out/macos/defaults.sh"
  chmod +x "$out/macos/defaults.sh"
}

render_variant personal true
render_variant work     false

cd "$PUB_ROOT"
echo "==> done"
echo ""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git status --short
  echo ""
  echo "Review the diff, then commit + push."
fi

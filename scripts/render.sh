#!/bin/bash
# render.sh — regenerate the public showcase from the private chezmoi sources.
#
# Renders the personal-Mac variant into the root of this repo, from either
# machine. Runs idempotently; safe to re-run. Wipes managed subdirs and
# rebuilds from scratch so deletions in the templates flow through cleanly.
#
# Do NOT edit the generated files directly — they are overwritten on each render.

set -euo pipefail

PUB_ROOT="${PUB_ROOT:-$HOME/dev/personal/dotfiles}"
CHEZMOI_SRC="$HOME/.local/share/chezmoi"

stage="$(mktemp -d -t chezmoi-render.XXXXXX)"
state="$(mktemp -t chezmoi-state.XXXXXX)"
trap 'rm -rf "$stage" "$state"' EXIT

echo "==> rendering personal variant"

chezmoi apply \
  --force \
  --exclude=scripts,encrypted,externals \
  --destination="$stage" \
  --persistent-state="$state" \
  --override-data '{"personal": true, "public": true}'

# Wipe only the tool-named subdirs we manage — leave README, LICENSE, scripts/, .git/, etc.
for d in aerospace bat btop fastfetch fd ghostty git homebrew karabiner lazygit macos mise navi nvim ripgrep sheldon starship tmux yazi yt-dlp zsh; do
  rm -rf "${PUB_ROOT:?}/$d"
done

# --- allowlist: what appears in the public showcase ---
cp -r "$stage/.config/aerospace"   "$PUB_ROOT/aerospace"
cp -r "$stage/.config/bat"         "$PUB_ROOT/bat"
cp -r "$stage/.config/btop"        "$PUB_ROOT/btop"
cp -r "$stage/.config/fastfetch"   "$PUB_ROOT/fastfetch"
[ -d "$stage/.config/fd"       ] && cp -r "$stage/.config/fd"       "$PUB_ROOT/fd"
cp -r "$stage/.config/ghostty"     "$PUB_ROOT/ghostty"
cp -r "$stage/.config/homebrew"    "$PUB_ROOT/homebrew"
cp -r "$stage/.config/karabiner"   "$PUB_ROOT/karabiner"
cp -r "$stage/.config/lazygit"     "$PUB_ROOT/lazygit"
cp -r "$stage/.config/mise"        "$PUB_ROOT/mise"
cp -r "$stage/.config/navi"        "$PUB_ROOT/navi"
cp -r "$stage/.config/nvim"        "$PUB_ROOT/nvim"
cp -r "$stage/.config/ripgrep"     "$PUB_ROOT/ripgrep"
cp -r "$stage/.config/sheldon"     "$PUB_ROOT/sheldon"
[ -d "$stage/.config/starship" ] && cp -r "$stage/.config/starship" "$PUB_ROOT/starship"
cp -r "$stage/.config/tmux"        "$PUB_ROOT/tmux"
cp -r "$stage/.config/yazi"        "$PUB_ROOT/yazi"
cp -r "$stage/.config/yt-dlp"      "$PUB_ROOT/yt-dlp"

mkdir -p "$PUB_ROOT/zsh"
cp "$stage/.zshenv"              "$PUB_ROOT/zsh/.zshenv.shim"
cp "$stage/.config/zsh/.zshrc"   "$PUB_ROOT/zsh/.zshrc"
cp "$stage/.config/zsh/.zshenv"  "$PUB_ROOT/zsh/.zshenv"
cp "$stage/.config/zsh/.zprofile" "$PUB_ROOT/zsh/.zprofile"

mkdir -p "$PUB_ROOT/git"
sed 's|!.*/bin/gh|!gh|g' "$stage/.config/git/config" > "$PUB_ROOT/git/config"

sed "s|$HOME|~|g" "$stage/.config/navi/config.yaml" > "$PUB_ROOT/navi/config.yaml"

if [ -f "$PUB_ROOT/mise/settings.toml" ]; then
  sed -i '' "s|$HOME|~|g" "$PUB_ROOT/mise/settings.toml"
fi

mkdir -p "$PUB_ROOT/macos"
cp "$CHEZMOI_SRC/home/.chezmoiscripts/darwin/run_onchange_after_08-macos-defaults.sh" \
   "$PUB_ROOT/macos/defaults.sh"
chmod +x "$PUB_ROOT/macos/defaults.sh"

cd "$PUB_ROOT"
echo "==> done"
echo ""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git status --short
  echo ""
  echo "Review the diff, then commit + push."
fi

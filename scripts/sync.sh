#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
CONFIG="$HOME/.config"

echo "syncing dotfiles..."

cp "$CONFIG/aerospace/aerospace.toml"       "$DOTFILES/aerospace/"
cp "$CONFIG/bat/config"                     "$DOTFILES/bat/"
rm -f "$DOTFILES/btop/themes/"* 2>/dev/null || true
cp "$CONFIG/btop/themes/"* "$DOTFILES/btop/themes/" 2>/dev/null || true
cp "$CONFIG/fd/ignore"                      "$DOTFILES/fd/" 2>/dev/null || true
cp "$CONFIG/ghostty/config"                 "$DOTFILES/ghostty/"
cp "$CONFIG/homebrew/Brewfile"              "$DOTFILES/homebrew/"
cp "$CONFIG/karabiner/karabiner.json"       "$DOTFILES/karabiner/"
cp "$CONFIG/lazygit/config.yml"             "$DOTFILES/lazygit/"
cp "$CONFIG/fastfetch/config.jsonc"          "$DOTFILES/fastfetch/"
cp "$CONFIG/fastfetch/logo.txt"              "$DOTFILES/fastfetch/"
cp "$CONFIG/mise/config.toml"               "$DOTFILES/mise/"
rm -f "$DOTFILES/navi/custom/"*.cheat
cp "$CONFIG/navi/custom/"*.cheat            "$DOTFILES/navi/custom/"
cp "$CONFIG/ripgrep/config"                 "$DOTFILES/ripgrep/"
cp "$CONFIG/sheldon/plugins.toml"           "$DOTFILES/sheldon/"
cp "$CONFIG/starship/starship.toml"         "$DOTFILES/starship/" 2>/dev/null || true
cp "$CONFIG/tmux/tmux.conf"                 "$DOTFILES/tmux/"
cp "$CONFIG/yazi/yazi.toml"                 "$DOTFILES/yazi/"
cp "$CONFIG/yazi/theme.toml"                "$DOTFILES/yazi/" 2>/dev/null || true
cp "$CONFIG/yt-dlp/config"                  "$DOTFILES/yt-dlp/"

cp "$CONFIG/nvim/init.lua"                  "$DOTFILES/nvim/"
rm -f "$DOTFILES/nvim/lua/config/"*.lua
cp "$CONFIG/nvim/lua/config/"*.lua          "$DOTFILES/nvim/lua/config/"
rm -f "$DOTFILES/nvim/lua/plugins/"*.lua
cp "$CONFIG/nvim/lua/plugins/"*.lua         "$DOTFILES/nvim/lua/plugins/"

cp "$HOME/.zshrc"                           "$DOTFILES/zsh/.zshrc"
cp "$HOME/.zshenv"                          "$DOTFILES/zsh/.zshenv"
cp "$HOME/.zprofile"                        "$DOTFILES/zsh/.zprofile"

sed 's|!.*/bin/gh|!gh|g' \
    "$CONFIG/git/config" > "$DOTFILES/git/config"

sed "s|$HOME|~|g" \
    "$CONFIG/navi/config.yaml" > "$DOTFILES/navi/config.yaml"

cp "$HOME/.local/share/chezmoi/home/.chezmoiscripts/darwin/run_onchange_after_08-macos-defaults.sh" \
    "$DOTFILES/macos/defaults.sh"
chmod +x "$DOTFILES/macos/defaults.sh"

echo ""
cd "$DOTFILES"
git diff --stat
echo ""
git status --short
echo ""
echo "done. review changes then commit."

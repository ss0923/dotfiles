if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# JetBrains Toolbox — shell scripts for IDE launchers (no-op if dir doesn't exist)
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

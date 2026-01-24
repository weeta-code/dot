
eval "$(zoxide init zsh)"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# mise - polyglot tool version manager
eval "$($HOME/.local/bin/mise activate zsh)"

# opencode
export PATH=/Users/mira/.opencode/bin:$PATH

# Run neofetch on interactive shells
if [[ -o interactive ]]; then
  neofetch
fi

# bun completions
[ -s "/Users/mira/.bun/_bun" ] && source "/Users/mira/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

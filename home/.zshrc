# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="inrainbows"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Environment
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# Tools
eval "$(zoxide init zsh)"
eval "$($HOME/.local/bin/mise activate zsh)"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# neofetch on interactive shells
[[ -o interactive ]] && neofetch

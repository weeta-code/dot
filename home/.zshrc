# Powerlevel10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

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

# Powerlevel10k config (run `p10k configure` to customize)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

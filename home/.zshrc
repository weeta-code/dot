# Powerlevel10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Environment
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"

# script
define() {
  curl -S "dict://dict.org/d:$1"
}

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
[[ -o interactive ]] && sleep 0.1 && neofetch

# Powerlevel10k config (run `p10k configure` to customize)
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# aliases
alias mpd='mpd ~/.config/mpd/mpd.conf'
alias shuffle='mpc shuffle'
alias update='mpc update'
alias reboot='pkill mpd && mpd'

# embedder
export PATH="/Users/mira/.embedder/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"

# bun completions
[ -s "/Users/vd/.bun/_bun" ] && source "/Users/vd/.bun/_bun"



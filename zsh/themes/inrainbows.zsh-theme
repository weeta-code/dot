# In Rainbows - minimal prompt with warm orange accent
# Color: #F25A16 (Radiohead - In Rainbows palette)

# Use true color if supported, fallback to 256-color 202
if [[ "$COLORTERM" == "truecolor" ]] || [[ "$COLORTERM" == "24bit" ]]; then
  ORANGE="%F{#F25A16}"
else
  ORANGE="%F{202}"
fi
RESET="%f"

# Git info
ZSH_THEME_GIT_PROMPT_PREFIX=" ${ORANGE}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")${RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Prompt: directory (git)
PROMPT='${ORANGE}%~${RESET}$(git_prompt_info) %(?.$.${ORANGE}$${RESET}) '

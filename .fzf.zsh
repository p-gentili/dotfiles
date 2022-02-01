# Setup fzf
# ---------
if [[ ! "$PATH" == */home/pgentili/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/pgentili/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/pgentili/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/pgentili/.fzf/shell/key-bindings.zsh"

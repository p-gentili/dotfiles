# Include
if [ -f ~/.zsh_alias ]; then
    source ~/.zsh_alias
else
    print "404: ~/.zsh_alias not found."
fi

if [ -f ~/.zsh_custom_alias ]; then
    source ~/.zsh_custom_alias
fi

# Plugins
source ~/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/zsh/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%F{208}(%b)%f '
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%~ $ '
RPROMPT=\$vcs_info_msg_0_


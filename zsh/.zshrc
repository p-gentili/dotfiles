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
source ~/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
bindkey '^ ' autosuggest-accept

# Autocomplete matches caps letter
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Fzf bindings
source ~/dotfiles/zsh/fzf/key-bindings.zsh
source ~/dotfiles/zsh/fzf/completion.zsh

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%F{160}%u%f %F{40}%c%f %F{208}(%b)%f '
 
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%~ '
RPROMPT=\$vcs_info_msg_0_

# Save history to file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
  '+l:|?=** r:|?=**'

# Initialize the autocompletion
autoload -Uz compinit && compinit -i

# Path
export PATH=$HOME/.local/bin:$PATH
[ -f ~/.cargo/env ] && source ~/.cargo/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Plugins - Must source at the end
source ~/dotfiles/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

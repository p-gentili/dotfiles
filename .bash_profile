#Custom aliases
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'

alias p3='python3'

#alias ipy='ipython'

alias rpi='ssh pi@192.168.1.15'

alias bup='brew upgrade && brew cask upgrade'
alias bcl='brew cleanup -s'
alias bupcl='bup ; bcl'

#Updated paths
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="$PATH:~/Workspace/flutter/bin"

#GIT autocomplete
if [ -f ~/.git-completion.bash ]; then 
    . ~/.git-completion.bash 
fi


test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


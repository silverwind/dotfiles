#######################################################
# prompt
#######################################################

export PS1="\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \[\e[32m\]\w\[\e[m\] \e[35m\]$\[\e[m\] "

#######################################################
# shopt
#######################################################

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s dotglob
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s hostcomplete
shopt -s interactive_comments
shopt -s no_empty_cmd_completion
shopt -s nocaseglob
shopt -s nocasematch

#######################################################
# environment
#######################################################

export EDITOR=vim
export GLOBIGNORE=1
export GREP_COLOR='1;31'
export HISTCONTROL=ignoredups
export HISTFILESIZE=100000
export HISTSIZE=100000
export PAGER=less
export TERM=xterm-256color
export VISUAL=vim

#######################################################
# misc
#######################################################

bind 'set completion-ignore-case on'

if [ -t 0 ]; then
  stty -ixon -ixoff
fi

#######################################################
# aliases
#######################################################

alias ls='ls --color=auto'
alias ll='ls -la'
alias l='ll'
alias grep='grep --color=auto -i'
alias rm='rm -vR'
alias ..='cd..'
alias ...='cd...'

#######################################################
# source .bash_profile.local
#######################################################

if [ -f "$HOME/.bash_profile.local" ]; then source "$HOME/.bash_profile.local"; fi

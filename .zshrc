#!/usr/bin/env zsh
#     ::::::::: ::::::::  :::    ::: :::::::::   ::::::::
#          :+: :+:    :+: :+:    :+: :+:    :+: :+:    :+:
#         +:+  +:+        +:+    +:+ +:+    +:+ +:+
#        +#+   +#++:++#++ +#++:++#++ +#++:++#:  +#+
#       +#+           +#+ +#+    +#+ +#+    +#+ +#+
# #+#  #+#     #+#    #+# #+#    #+# #+#    #+# #+#    #+#
# ### ######### ########  ###    ### ###    ###  ########

#######################################################
# zplug
#######################################################

source ~/.zplug/init.zsh

zplug "modules/completion",                from:prezto
zplug "lib/history",                       from:oh-my-zsh
zplug "zsh-users/zsh-completions",         defer:2
zplug "plugins/history-substring-search",  from:oh-my-zsh, defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

#######################################################
# prompt
#######################################################

autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[grey]%}%s %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"
precmd () { vcs_info }
PS1='%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[blue]%}%m %{$fg[green]%}%~ %{$fg[yellow]%}$ %{$reset_color%}'
RPS1='%(?..%{$fg[red]%}%?%{$reset_color%} )${vcs_info_msg_0_}'

#######################################################
# tweaks
#######################################################

if hash tabs &>/dev/null; then tabs -2; fi            # tab size 2
if hash nvim &>/dev/null; then alias vim ="nvim"; fi  # alias vim to nvim

#######################################################
# key bindings
#######################################################

if zplug check plugins/history-substring-search; then
  bindkey '\eOA' history-substring-search-up
  bindkey '\eOB' history-substring-search-down
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^X' kill-whole-line
bindkey ' ' magic-space
bindkey -M viins ' ' magic-space

# map all possible home/end key escape sequences
bindkey '\e[H' beginning-of-line # Cygwin
bindkey '\e[F' end-of-line       # Cygwin
bindkey "e[1~" beginning-of-line
bindkey "e[4~" end-of-line
bindkey "e[7~" beginning-of-line
bindkey "e[8~" end-of-line
bindkey "eOH" beginning-of-line
bindkey "eOF" end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

#######################################################
# zsh options
#######################################################

unsetopt ALL_EXPORT

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

setopt AUTO_LIST
setopt AUTO_PARAM_SLASH
setopt AUTO_RESUME
setopt BG_NICE
setopt CDABLE_VARS
setopt COMPLETE_IN_WORD
setopt GLOB_DOTS
setopt LONG_LIST_JOBS
setopt MAIL_WARNING
setopt MENU_COMPLETE
setopt NOTIFY
setopt PUSHD_MINUS
setopt RC_QUOTES
setopt REC_EXACT
setopt GLOBSTAR_SHORT
setopt DOT_GLOB

setopt ALL_EXPORT

#######################################################
# dircolors
#######################################################

if [ -f "$HOME/.dircolors" ]; then
  if hash dircolors &>/dev/null; then
    eval $(dircolors -b $HOME/.dircolors)
  fi
  if hash gdircolors &>/dev/null; then
    eval $(gdircolors -b $HOME/.dircolors)
  fi
fi

#######################################################
# useful functions/aliases
#######################################################

# add open, pbcopy and pbpaste commands on Cygwin and Linux
if [[ "$OSTYPE" == cygwin* ]]; then
  alias open='cygstart'
  alias pbcopy='cat > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
elif [[ "$OSTYPE" == linux* ]]; then
  alias open='xdg-open'
  if (( $+commands[xclip] )); then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

# create a directory and cd into it
md() {
  mkdir -p "$@" && cd "$@"
}

# cat with sytnax highlighting
ct() {
  pygmentize -O style=monokai -f console256 -g "$@"
}

# expand ... to ../..
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert

# finds files and executes a command on them
findexec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

#######################################################
# command correction
#######################################################

setopt CORRECT
alias cd='nocorrect cd'
alias cp='nocorrect cp -vr'
alias gcc='nocorrect gcc'
alias grep='nocorrect grep'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir -p'
alias mv='nocorrect mv'
alias mysql='nocorrect mysql'
alias rm='nocorrect rm -rfv'

alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

#######################################################
# terminal title with hostname, based on
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
#######################################################

function title {
  print -Pn "\e]0;${HOST}:%~\a"
  print -Pn "\e]1;${HOST}:%~\a"
  print -Pn "\e]2;${HOST}:%~\a"
}

function title_preexec {
  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"
  title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(title)           # Runs before showing the prompt
preexec_functions+=(title_preexec)  # Runs before executing the command

#######################################################
# source .zshrc.local
#######################################################

if [ -f "$HOME/.zshrc.local" ]; then source "$HOME/.zshrc.local"; fi
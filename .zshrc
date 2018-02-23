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

zplug "plugins/history-substring-search", defer:2, from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-completions", defer:3

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

if hash tabs &>/dev/null; then tabs -4 &>/dev/null; fi # tab size
if hash setterm &>/dev/null; then setterm -regtabs 4 &>/dev/null; fi # tab size (compat)
if hash nvim &>/dev/null; then alias vim="nvim"; fi  # alias vim to nvim

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

# bind all possible home/end/delete key escape sequences
bindkey '\e[H' beginning-of-line # Cygwin
bindkey "e[1~" beginning-of-line # OSX
bindkey '^[OH' beginning-of-line  # Linux
bindkey "e[7~" beginning-of-line
bindkey "eOH" beginning-of-line

bindkey '\e[F' end-of-line       # Cygwin
bindkey "^[[4~" end-of-line      # OSX
bindkey '^[OF' end-of-line       # Linux
bindkey "e[4~" end-of-line
bindkey "e[8~" end-of-line
bindkey "eOF" end-of-line

bindkey "^[[3~" delete-char      # Cygwin
bindkey "\e[3~" delete-char
bindkey "^[3;5~" delete-char

bindkey '^?' backward-delete-char

#######################################################
# zsh options
#######################################################

# reduce key timeout to .1s
export KEYTIMEOUT=1

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

# history options
HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

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
# completion - based on zprezto
#######################################################

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
autoload -Uz compinit
_comp_files=(${ZDOTDIR:-$HOME}/.zcompdump(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C
else
  compinit -i
fi
unset _comp_files

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':prezto:module:completion:*' case-sensitive; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' hosts off

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

#######################################################
# useful functions/aliases
#######################################################

# add open, copy, pbcopy and pbpaste commands on Cygwin and Linux
if [[ "$OSTYPE" == cygwin* ]]; then
  alias open='cygstart'
  alias copy='cat > /dev/clipboard'
  alias pbcopy='cat > /dev/clipboard'
  alias pbpaste='cat /dev/clipboard'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias copy='pbcopy'
elif [[ "$OSTYPE" == linux* ]]; then
  alias open='xdg-open'
  if (( $+commands[xclip] )); then
    alias copy='xclip -selection clipboard -in'
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif (( $+commands[xsel] )); then
    alias copy='xsel --clipboard --input'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

# banish files from git history
grem() {
  git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $@" --prune-empty --tag-name-filter cat -- --all
}

# create a directory and cd into it
md() {
  mkdir -p "$@" && cd "$@"
}

# cat with sytnax highlighting
ct() {
  pygmentize -O style=monokai -f console256 -g "$@"
}

# finds files and executes a command on them
findexec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Update packages on various package managers
u() {
  set -x
  if hash pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm
  fi
  if hash softwareupdate &>/dev/null; then
    sudo softwareupdate -i -a
  fi
  if hash brew &>/dev/null; then
    brew update; brew upgrade; brew cleanup; brew linkapps; brew prune
  fi
  if hash yarn &>/dev/null; then
    yarn global upgrade
  fi
  if hash rustup &>/dev/null; then
    rustup update stable
  fi
}

#######################################################
# general aliases
#######################################################

setopt CORRECT
alias cd='nocorrect cd'
alias cp='nocorrect cp -v -R'
alias find='noglob find'
alias ftp='noglob ftp'
alias gcc='nocorrect gcc'
alias grep='nocorrect grep'
alias history='fc -il 1'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias map="xargs -n1"
alias mkdir='nocorrect mkdir -p'
alias mv='nocorrect mv'
alias path='echo -e ${PATH//:/\\n}'
alias rm='nocorrect rm -rfv'
alias rsync='noglob rsync'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="curl -iX '$method'"
done

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

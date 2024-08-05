#!/usr/bin/env zsh

#######################################################
# zinit
#######################################################

source ~/.zinit/bin/zinit.zsh
zinit light silverwind/zsh-history-substring-search # https://github.com/zsh-users/zsh-history-substring-search/pull/159
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

#######################################################
# prompt
#######################################################

source ~/.gitstatus/gitstatus.plugin.zsh

autoload -U colors && colors
autoload -Uz add-zsh-hook

function gitstatus_prompt_update() {
  emulate -L zsh
  typeset -g  GITSTATUS_PROMPT=''
  typeset -gi GITSTATUS_PROMPT_LEN=0

  # Call gitstatus_query synchronously. Note that gitstatus_query can also be called
  # asynchronously; see documentation in gitstatus.plugin.zsh.
  gitstatus_query 'MY'                  || return 1  # error
  [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0  # not a git repo

  local clean='%39F'
  local conflicted='%196F'

  local p='%244Fgit '
  local where  # branch name, tag or commit
  if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
    where=$VCS_STATUS_LOCAL_BRANCH
  elif [[ -n $VCS_STATUS_TAG ]]; then
    p+='%f#'
    where=$VCS_STATUS_TAG
  else
    p+='%f@'
    where=${VCS_STATUS_COMMIT[1,8]}
  fi

  p+="${clean}${where//\%/%%}" # escape %
  # ⇣42 if behind the remote.
  (( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
  # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
  (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
  (( VCS_STATUS_COMMITS_AHEAD )) && p+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
  # ⇠42 if behind the push remote.
  (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
  (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
  (( VCS_STATUS_PUSH_COMMITS_AHEAD )) && p+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
  # 'merge' if the repo is in an unusual state.
  [[ -n $VCS_STATUS_ACTION ]] && p+=" ${conflicted}${VCS_STATUS_ACTION}"
  GITSTATUS_PROMPT="${p}%f"
}

gitstatus_stop 'MY' && gitstatus_start 'MY'
add-zsh-hook precmd gitstatus_prompt_update
setopt no_prompt_bang prompt_percent prompt_subst

PS1='%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[blue]%}%m %{$fg[green]%}%~ %{$fg[yellow]%}$ %{$reset_color%}'
RPS1='$GITSTATUS_PROMPT'

#######################################################
# tweaks
#######################################################

if hash tabs &>/dev/null; then tabs -4 &>/dev/null; fi # tab size
if hash setterm &>/dev/null; then setterm -regtabs 4 &>/dev/null; fi # tab size (compat)
if which umask &>/dev/null; then umask 022; fi # set umask
if [[ "$OSTYPE" == darwin* ]]; then ulimit -n 12288; fi # increase open files limit on darwin

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=none,fg=default'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=none,fg=default'

#######################################################
# key bindings
#######################################################

autoload -U compinit
compinit -u

bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^X' kill-whole-line
bindkey ' ' magic-space
bindkey -M viins ' ' magic-space

# bind all possible home/end/delete key escape sequences
bindkey '\e[H' beginning-of-line # Cygwin
bindkey "e[1~" beginning-of-line # macOS
bindkey '^[OH' beginning-of-line # Linux
bindkey "e[7~" beginning-of-line
bindkey "eOH" beginning-of-line

bindkey '\e[F' end-of-line       # Cygwin
bindkey "^[[4~" end-of-line      # macOS
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

# word-breaking characters (default minus _ and -)
export WORDCHARS="*?.[]~=/&;!#$%^(){}<>"

unsetopt ALL_EXPORT

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
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
setopt NOTIFY
setopt PUSHD_MINUS
setopt RC_QUOTES
setopt REC_EXACT
setopt GLOBSTAR_SHORT &> /dev/null
setopt DOT_GLOB
setopt RM_STARSILENT         # disable confirmation on rm

# history options
HISTFILE=$HOME/.zsh_history
HISTSIZE=999999999
SAVEHIST=999999999
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
  elif hash gdircolors &>/dev/null; then
    eval $(gdircolors -b $HOME/.dircolors)
  fi
fi

#######################################################
# completion - based on zprezto
#######################################################

setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt MENU_COMPLETE       # Auio-select first match
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' rehash true # Automatically update PATH entries
zstyle ':completion:*' menu select=0
zstyle ':completion:*' verbose true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' show-completer true # Show which completer is currently running
zstyle ':completion:*' single-ignored show
zstyle ':completion:*' users off
zstyle ':completion:*' special-dirs ..
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:correct:*' insert-unambiguous true
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:-command-:*:' verbose false
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle -e ':completion:*' hosts 'reply=()'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

#######################################################
# useful functions/aliases
#######################################################

# add open, copy, pbcopy and pbpaste commands on Cygwin and Linux
if [[ "$OSTYPE" == cygwin* ]]; then
  alias open='cygstart'
  alias copy='cat > /dev/clipboard'
elif [[ "$OSTYPE" == darwin* ]]; then
  alias copy='pbcopy'
elif [[ "$OSTYPE" == linux* ]]; then
  alias open='xdg-open'
  if (( $+commands[xclip] )); then
    alias copy='xclip -selection clipboard -in'
  elif (( $+commands[xsel] )); then
    alias copy='xsel --clipboard --input'
  fi
fi

# create a directory and cd into it
md() {
  mkdir -p "$@" && cd "$@"
}

#######################################################
# aliases
#######################################################

alias history='fc -il 1'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ls='ls -lh --color=auto --group-directories-first'
alias l='ls'
alias ll='ls'
alias lla='ll -a'
alias rm='rm -rf'
alias cp='cp -r'
alias ip='ip -c'
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias ag='ag -u --color-match "1;32" --color-path "1;34" --filename'
alias rg='rg --no-heading --hidden --glob "!.git" --smart-case --colors "path:fg:blue" --colors "match:fg:green" --colors "line:fg:yellow"'
alias gti='git'
alias g='git'
alias maek='make'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit -n 15 && echo"
alias gl="glog"
alias gcommit='git commit -a -m'
alias gc='gcommit'
alias greset='git reset --soft HEAD~1'
alias gr='greset'
alias gamend='git commit --amend'
alias gp='gpush'

gpush() {
  BRANCH_NAME="$(git remote show origin | grep "HEAD branch" | sed 's/.*: //')"
  git push -u --follow-tags origin "$BRANCH_NAME" $@
}

gpull() {
  BRANCH_NAME="$(git remote show origin | grep "HEAD branch" | sed 's/.*: //')"
  git pull --tags --force origin "$BRANCH_NAME" $@
}

# set branch to any remote branch: "gct origin/foo"
gct() {
  BRANCH_NAME="$(git remote show origin | grep "HEAD branch" | sed 's/.*: //')"
  git fetch $(echo $1 | cut -d '/' -f 1)
  git checkout "$BRANCH_NAME"
  git branch -D "$(basename $1)" || true
  git checkout -t "$1"
}

#######################################################
# pager
#######################################################

export PAGER='most'
export MANPAGER='most'

#######################################################
# title - based on https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/termsupport.zsh
#######################################################

function title {
  setopt localoptions nopromptsubst

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*|foot)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;${2:q}\a" # set window name
        print -Pn "\e]1;${1:q}\a" # set tab name
      else
        # Try to use terminfo to set the title if the feature is available
        if (( ${+terminfo[fsl]} && ${+terminfo[tsl]} )); then
          print -Pn "${terminfo[tsl]}$1${terminfo[fsl]}"
        fi
      fi
      ;;
  esac
}

function termsupport_precmd {
  [[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return
  title "%15<..<%~%<<" "%n@%m:%~"
}

function termsupport_preexec {
  [[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return
  emulate -L zsh
  setopt extended_glob

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  title "$CMD" "%100>...>${LINE}%<<"
}

add-zsh-hook precmd termsupport_precmd
add-zsh-hook preexec termsupport_preexec

#######################################################
# source .zshrc.local
#######################################################

if [ -f "$HOME/.zshrc.local" ]; then source "$HOME/.zshrc.local"; fi

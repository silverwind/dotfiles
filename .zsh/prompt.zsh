autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%{$fg[grey]%}%s %{$fg[blue]%}%b%{$reset_color%}%m%u%c%{$reset_color%}"
precmd () { vcs_info }
PS1='%{$fg[red]%}%n%{$fg[yellow]%}@%{$fg[blue]%}%m %{$fg[yellow]%}%~ %{$fg[blue]%}$ %{$reset_color%}'
RPS1='${vcs_info_msg_0_}'

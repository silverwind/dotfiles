# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html

# enable dotfile globs but prevent . and .. from matching
shopt -s dotglob
export GLOBIGNORE=1

# enable **/* globs
shopt -s globstar

# misc stuff
shopt -s cdspell checkwinsize cmdhist dirspell histappend nocaseglob nocasematch

#!/bin/bash

set -x

install () {
  rm -rf "$2"
  mkdir -p "$(dirname "$2")"
  if [ -f /usr/bin/cygwin1.dll ]; then
    cp -Ra "$1" "$2"
  else
    ln -s "$1" "$2"
  fi
}

###############################################################################
# copy dotfiles
###############################################################################

cwd="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

declare -a files=(
  .config/htop/.htoprc
  .agignore
  .dircolors
  .editorconfig
  .eslintrc
  .gitconfig
  .gitignore
  .hgrc
  .hushlogin
  .inputrc
  .ls++.conf
  .curlrc
  .wgetrc
  .vim
  .vimrc
  .zshrc
)

for file in "${files[@]}"; do
  install "$cwd/$file" "$HOME/$file"
done

###############################################################################
# create sample .gitconfig.local if it doesn't exist
###############################################################################

if [ ! -f "$HOME/.gitconfig.local" ]; then
  cp -Ra "$cwd/.gitconfig.local" "$HOME"
fi

###############################################################################
# create empty .zshrc.local if it doesn't exist
###############################################################################

if [ ! -f "$HOME/.zshrc.local" ]; then
  touch "$HOME/.zshrc.local"
fi

###############################################################################
# nvim
###############################################################################

install "$cwd/.vim" "$HOME/.config/nvim"
install "$cwd/.vimrc" "$HOME/.config/nvim/init.vim"

###############################################################################
# install vim plug
###############################################################################

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

###############################################################################
# install zplug
###############################################################################

if [ ! -d "$HOME/.zplug" ]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

###############################################################################
# finish
###############################################################################

echo -e 'Installation done!'
echo -e ' 1. Run \e[31mvim -c ":PlugInstall"\e[0m to install vim plugins'
echo -e ' 2. Restart your terminal to install zsh plugins'

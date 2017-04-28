#!/bin/bash

set -x

###############################################################################
# copy dotfiles
###############################################################################

cwd="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

mkdir -p "$HOME/.zsh"
mkdir -p "$HOME/.config/htop"

declare -a files=(
  .config/htop/.htoprc
  .agignore
  .dircolors
  .editorconfig
  .eslintrc
  .gitconfig
  .hgrc
  .hushlogin
  .inputrc
  .ls++.conf
  .curlrc
  .wgetrc
  .zshrc
)

for file in "${files[@]}"; do
  rm -rf "$HOME/$file"
  if [ -f /usr/bin/cygwin1.dll ]; then
    cp -Ra "$cwd/$file" "$HOME"
  else
    ln -s "$cwd/$file" "$HOME"
  fi
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
# vim / nvim
###############################################################################

# clean up
rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"
rm -rf "$HOME/.config/nvim"

# vim
if [ -f /usr/bin/cygwin1.dll ]; then
  cp -Ra "$cwd/.vimrc" "$HOME"
  cp -Ra "$cwd/.vim" "$HOME"
else
  ln -s "$cwd/.vimrc" "$HOME"
  ln -s "$cwd/.vim" "$HOME"
fi

# nvim
mkdir -p "$HOME/.config"
if [ -f /usr/bin/cygwin1.dll ]; then
  cp -Ra "$cwd/.vim" "$HOME/.config/nvim"
else
  ln -s "$cwd/.vim" "$HOME/.config/nvim"
fi

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

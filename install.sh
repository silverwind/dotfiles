#!/bin/bash

###############################################################################
# general dotfiles
###############################################################################

set -x

cwd="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

declare -a files=(
  .dircolors
  .editorconfig
  .eslintrc
  .gitconfig
  .hgrc
  .htoprc
  .hushlogin
  .inputrc
  .ls++.conf
  .curlrc
  .wgetrc
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

if [ ! -f "$HOME/.gitconfig.local" ] && [ ! -l "$HOME/.gitconfig.local" ]; then
  cp -Ra "$cwd/.gitconfig.local" "$HOME"
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

# get plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install plugins
vim -c ":PlugInstall"

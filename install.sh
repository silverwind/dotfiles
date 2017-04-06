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
  cp -ra "$cwd/$file" "$HOME"
done

###############################################################################
# create sample .gitconfig.local if it doesn't exist
###############################################################################

if [ ! -f "$HOME/.gitconfig.local" ] && [ ! -l "$HOME/.gitconfig.local" ]; then
  cp -ra "$cwd/.gitconfig.local" "$HOME"
fi

###############################################################################
# vim / nvim
###############################################################################

# clean up
rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"
rm -rf "$HOME/.config/nvim"

# vim
cp -ra "$cwd/.vimrc" "$HOME"
cp -ra "$cwd/.vim" "$HOME"

# nvim
mkdir -p "$HOME/.config"
cp -ra "$cwd/.vim" "$HOME/.config/nvim"

# get plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install plugins
vim -c ":PlugInstall"

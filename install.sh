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
  ln -s "$cwd/$file" "$HOME"
done

###############################################################################
# vim / nvim
###############################################################################

# clean up
rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"
rm -rf "$HOME/.config/nvim"

# vim
ln -s "$cwd/.vimrc" "$HOME"
ln -s "$cwd/.vim" "$HOME"

# nvim
mkdir -p "$HOME/.config"
ln -s "$cwd/.vim" "$HOME/.config/nvim"

# get plug
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install plugins
vim -c ":PlugInstall"

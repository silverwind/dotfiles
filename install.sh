#!/bin/bash

###############################################################################
# general dotfiles
###############################################################################

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

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

for file in "${files[@]}"; do
  rm -rf "$HOME/$file"
  ln -s "$DIR/$file" "$HOME"
done

source "$DIR/install-vim.sh"


###############################################################################
# vim / nvim
###############################################################################

# clean up
rm -rf ~/.vim
rm -rf ~/.vimrc
rm -rf ~/.config/nvim

# vim
ln -s "$(pwd)/.vimrc" ~
ln -s "$(pwd)/.vim" ~

# nvim
mkdir -p ~/.config
ln -s "$(pwd)/.vim" ~/.config/nvim
ln -s "$(pwd)/.vimrc" ~/.config/nvim/init.vim

# get plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install plugins
vim -c ":PlugInstall"

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
  .bashrc
  .bash_profile
  .curlrc
  .dircolors
  .editorconfig
  .gitconfig
  .gitignore
  .hgrc
  .hushlogin
  .inputrc
  .ls++.conf
  .mostrc
  .minttyrc
  .ncmpcpp
  .npmrc
  .psqlrc
  .tmux.conf
  .vim
  .vimrc
  .wgetrc
  .yarnrc
  .zshrc
)

for file in "${files[@]}"; do
  install "$cwd/$file" "$HOME/$file"
done

# install selected files into $USERPROFILE
declare -a winfiles=(
  .npmrc
  .yarnrc
  .eslintrc
  .gitconfig
  .gitignore
)

if [ -f /usr/bin/cygwin1.dll ]; then
  winhome=$(cygpath $USERPROFILE)
  for file in "${winfiles[@]}"; do
    install "$cwd/$file" "$winhome/$file"
  done
fi

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

vim -c ':PlugInstall! | :q! | :q!'

###############################################################################
# install zplug
###############################################################################

rm -rf $HOME/.zplug
curl -sL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

###############################################################################
# install tpm
###############################################################################

rm -rf $HOME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

###############################################################################
# finish
###############################################################################

echo -e "Installation done. Restart you shell to install zplug."

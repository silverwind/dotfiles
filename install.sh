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
  .agignore
  .bash_profile
  .bashrc
  .cargo/config
  .config/htop/.htoprc
  .curlrc
  .dircolors
  .editorconfig
  .gitconfig
  .gitignore
  .hgrc
  .hushlogin
  .inputrc
  .ls++.conf
  .minttyrc
  .mostrc
  .ncmpcpp
  .psqlrc
  .tmux.conf
  .wgetrc
  .yarnrc
  .zshrc
)

for file in "${files[@]}"; do
  install "$cwd/$file" "$HOME/$file"
done

# install selected files into $USERPROFILE
declare -a winfiles=(
  .cargo/config
  .eslintrc
  .gitconfig
  .gitignore
  .npmrc
  .yarnrc
)

if [ -f /usr/bin/cygwin1.dll ]; then
  winhome=$(cygpath $USERPROFILE)
  for file in "${winfiles[@]}"; do
    install "$cwd/$file" "$winhome/$file"
  done
fi

###############################################################################
# create sample files if they doesn't exist
###############################################################################

if [ ! -f "$HOME/.gitconfig.local" ]; then
  cp -Ra "$cwd/.gitconfig.local" "$HOME"
fi

if [ ! -f "$HOME/.npmrc" ]; then
  cp -Ra "$cwd/.npmrc" "$HOME"
fi

if [ -f /usr/bin/cygwin1.dll ]; then
  winhome=$(cygpath $USERPROFILE)
  if [ ! -f "$winhome/.npmrc" ]; then
    cp -Ra "$cwd/.npmrc" "$winhome"
  fi
fi

if [ ! -f "$HOME/.zshrc.local" ]; then
  touch "$HOME/.zshrc.local"
fi

###############################################################################
# nvim, vim, vim-plug
###############################################################################

rm -rf "$HOME/.config/nvim"

install "$cwd/.vim" "$HOME/.config/nvim"
install "$cwd/.vimrc" "$HOME/.config/nvim/init.vim"

rm -rf "$HOME/.vim"
rm -rf "$HOME/.vimrc"

install "$cwd/.vim" "$HOME/.vim"
install "$cwd/.vimrc" "$HOME/.vimrc"

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

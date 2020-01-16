#!/usr/bin/env bash
set -euxo pipefail

CWD="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

if [ -f /usr/bin/cygwin1.dll ]; then
  WINHOME=$(cygpath "$USERPROFILE")
fi

install () {
  rm -rf "$HOME/$2"
  mkdir -p "$(dirname "$HOME/$2")"

  if [[ -v WINHOME ]]; then
    rm -rf "$WINHOME/$2"
    mkdir -p "$(dirname "$WINHOME/$2")"
    cp -Ra "$CWD/$1" "$HOME/$2"
    cp -Ra "$CWD/$1" "$WINHOME/$2"
  else
    ln -s "$CWD/$1" "$HOME/$2"
  fi
}

uninstall () {
  if [[ -v WINHOME ]]; then
    rm -rf "$WINHOME/$1"
  fi
  rm -rf "$HOME/$1"
}

###############################################################################
# dotfiles
###############################################################################

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
  install "$file" "$file"
done

###############################################################################
# nvim, vim, vim-plug
###############################################################################

uninstall ".config/nvim"
uninstall ".vim"
uninstall ".vimrc"

install ".vim" ".config/nvim"
install ".vimrc" ".config/nvim/init.vim"
install ".vim" ".vim"
install ".vimrc" ".vimrc"

if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

vim -c ':PlugInstall! | :PlugUpdate! | :q! | :q!'

###############################################################################
# zplug
###############################################################################

rm -rf "$HOME/.zplug"
curl -sfL "https://raw.githubusercontent.com/zplug/installer/master/installer.zsh" | zsh

###############################################################################
#  tpm
###############################################################################

rm -rf "$HOME/.tmux/plugins/tpm"
git clone "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"

###############################################################################
# finish
###############################################################################

echo -e "Installation done. Restart you shell to install zplug."

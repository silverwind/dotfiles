#!/bin/bash

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

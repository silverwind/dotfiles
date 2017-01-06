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

set -x

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

for file in "${files[@]}"; do
  rm -rf "$HOME/$file"
  ln -s "$(pwd)/$file" "$HOME"
done

source "$DIR/install-vim.sh"

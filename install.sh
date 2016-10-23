#!/bin/bash

set -x

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

rm -rf ~/.gitconfig
ln -s "$(pwd)/.gitconfig" ~

source "$DIR/install-vim.sh"

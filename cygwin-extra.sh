#!/bin/bash
set -euxo pipefail

if [[ "$OSTYPE" != "cygwin" ]]; then
  echo "This script should only run on 'cygwin', not '$OSTYPE'."
  exit 1
fi

# sudo
curl -o sudo.zip $(curl -s https://api.github.com/repos/mattn/sudo/releases/latest | jq -r ".assets[0].browser_download_url")
unzip sudo.zip
rm -f sudo.zip
mv -f sudo.exe /usr/bin

# sshpass
git clone https://github.com/kevinburke/sshpass
cd sshpass
cp README.md README
./configure
make
make install
cd ..
rm -rf sshpass

# apt-cyg
install <(curl -s https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg) /bin

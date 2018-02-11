#!/bin/bash
set -euo pipefail

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
git clone git://github.com/kevinburke/sshpass.git
cd sshpass
./configure
make
make install

# netcat
git clone https://github.com/solrex/netcat
cd netcat
bash build.sh

# apt-cyg
lynx -source rawgit.com/transcode-open/apt-cyg/master/apt-cyg > apt-cyg
install apt-cyg /bin

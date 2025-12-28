#!/bin/sh

# exit immediately when any command fails 
set -e

red=$'\e[1;31m'
yel=$'\e[1;33m'
end=$'\e[0m'

platform=`uname`
arch=`dpkg --print-architecture`
sudo apt install -y yq
sudo cp dev /usr/local/bin/dev
# not sure if I should have this here, but it's not executable
# by default within docker container
sudo chmod +x /usr/local/bin/dev

if [[ $platform != "Linux" ]]; then
	echo "${red} unsupported platform, only Linux is supported for now :)${red}"
fi

echo "${yel}Installing rancher desktop..${yel}${end}"

curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
sudo apt update
sudo apt install -y rancher-desktop

echo "${yel}switching to rancher desktop context..${yel}${end}"
echo "${red}attention: you may need to install google cloud sdk to use this context${red}${end}"
kubectl config use-context rancher-desktop


echo "${yel}Installing skaffold..${yel}${end}"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-"$arch" && \
        sudo install skaffold /usr/local/bin/

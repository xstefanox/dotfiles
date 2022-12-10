#!/bin/bash

if [[ $EUID -ne 0]]
then
    echo "You must be root"
    exit 1
fi

UBUNTU_BASE_VERSION=kinetic

# kodi
add-apt-repository ppa:team-xbmc/ppa

# spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/spotify.gpg
echo "deb [signed-by=/etc/apt/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# heroku
curl -fsSL https://cli-assets.heroku.com/apt/release.key | sudo gpg --dearmor -o /etc/apt/keyrings/heroku.gpg
echo "deb [signed-by=/etc/apt/keyrings/heroku.gpg] https://cli-assets.heroku.com/apt ./" | sudo tee /etc/apt/sources.list.d/heroku.list

# nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# git
sudo add-apt-repository ppa:git-core/ppa

# docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_BASE_VERSION} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# ruby 2.x
apt-add-repository ppa:brightbox/ruby-ng

# ansible
apt-add-repository ppa:ansible/ansible

# PHP with support for multiple versions
add-apt-repository ppa:ondrej/php

# wine
apt-add-repository ppa:ubuntu-wine/ppa

# mysql workbench
echo "deb http://repo.mysql.com/apt/ubuntu/ $UBUNTU_BASE_VERSION workbench-8.0" >> /etc/apt/sources.list.d/mysql-workbench.list

# gpu drivers
add-apt-repository ppa:graphics-drivers/ppa

# google chrome
curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# geary
add-apt-repository ppa:geary-team/releases

# visual studio code
curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/vscodium.gpg
echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list

# terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $UBUNTU_BASE_VERSION main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# adoptium
curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg
echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $UBUNTU_BASE_VERSION main" | sudo tee /etc/apt/sources.list.d/adoptium.list

# Mozilla
add-apt-repository ppa:mozillateam/ppa


#!/bin/bash

if [[ $EUID -ne 0]]
then
    echo "You must be root"
    exit 1
fi

# atom
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
add-apt-repository ppa:webupd8team/atom

# sun jdk
add-apt-repository ppa:webupd8team/java

# kodi
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 91E7EE5E
add-apt-repository ppa:team-xbmc/ppa

# spotify
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2C19886
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# heroku
wget -O- https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
echo "deb http://toolbelt.heroku.com/ubuntu ./" | sudo tee /etc/apt/sources.list.d/heroku.list

# nodejs
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# vagrant (unofficial)
sudo apt-key adv --keyserver pgp.mit.edu --recv-key 2099F7A4
echo 'deb http://vagrant-deb.linestarve.com/ any main' | sudo tee /etc/apt/sources.list.d/vagrant.list

# git
sudo add-apt-repository ppa:git-core/ppa

# docker
sudo curl -fsSL https://get.docker.com/gpg
curl -fsSL https://get.docker.com/ | sh

# ruby 2.x
sudo apt-add-repository ppa:brightbox/ruby-ng

# ansible
apt-add-repository ppa:ansible/ansible

# wine
apt-add-repository ppa:ubuntu-wine/ppa

# mysql workbench
echo 'deb http://repo.mysql.com/apt/ubuntu/ precise workbench-6.2' > /etc/apt/sources.list.d/mysql-workbench.list
echo 'deb http://repo.mysql.com/apt/ubuntu/ vivid workbench-6.2' >> /etc/apt/sources.list.d/mysql-workbench.list

# gpu drivers
add-apt-repository ppa:graphics-drivers/ppa

# nginx
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C

# google chrome
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# geary
#add-apt-repository ppa:yorba/ppa
add-apt-repository ppa:geary-team/releases

# mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

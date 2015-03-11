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
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
add-apt-repository ppa:webupd8team/java

# kodi
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 91E7EE5E
add-apt-repository ppa:team-xbmc/ppa

# spotify
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# heroku
wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list

# nodejs
wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo 'deb https://deb.nodesource.com/node trusty main' > /etc/apt/sources.list.d/nodejs.list

# vagrant (unofficial)
apt-key adv --keyserver pgp.mit.edu --recv-key 2099F7A4
echo 'deb http://vagrant-deb.linestarve.com/ any main' > /etc/apt/sources.list.d/vagrant.list

# git
#apt-key adv --keyserver keyserver.ubuntu.com --recv-key E1DF1F24
add-apt-repository ppa:git-core/ppa

#!/bin/bash

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
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 94558F59
echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list

# heroku
wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -
echo "deb http://toolbelt.heroku.com/ubuntu ./" > /etc/apt/sources.list.d/heroku.list

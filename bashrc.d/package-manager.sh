#!/bin/bash

########################
## PACKAGE MANAGEMENT ##
########################

## dpkg-based distros package manager functions
if which dpkg &> /dev/null
then

    [[ $UID == 0 ]] && alias add='apt-get install' || alias add='sudo apt-get install'
    [[ $UID == 0 ]] && alias purge='apt-get autoremove' || alias purge='sudo apt-get autoremove'
    [[ $UID == 0 ]] && alias dist-upgrade='apt-get dist-upgrade' || alias dist-upgrade='sudo apt-get dist-upgrade'
    [[ $UID == 0 ]] && alias dist-sync='apt-get update' || alias dist-sync='sudo apt-get update'
    alias show='apt-cache show'
    alias list='dpkg -L'

    function search()
    {
        apt-cache search --names-only $@ | sort
    }

    function apt-list-from-repository()
    {
        eval "aptitude search '~S ~i (~O"$1")'"
    }

## rpm-based distros using yum package manager functions
elif which yum &> /dev/null
then
    [[ $UID == 0 ]] && alias add='yum install' || alias add='sudo yum install'
    [[ $UID == 0 ]] && alias purge='yum erase' || alias purge='sudo yum erase'
    [[ $UID == 0 ]] && alias dist-upgrade='yum upgrade' || alias dist-upgrade='sudo yum upgrade'
    alias dist-sync='yum check-update'
    alias search='yum search'
    alias show='yum info'
    alias list='repoquery --list'
fi

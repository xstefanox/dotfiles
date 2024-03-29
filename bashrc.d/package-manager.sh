#!/bin/bash

########################
## PACKAGE MANAGEMENT ##
########################

## dpkg-based distros package manager functions
if which dpkg &> /dev/null
then
    if which nala &> /dev/null
    then
        alias add='sudo nala install'
        alias purge='sudo nala purge'
        alias dist-upgrade='sudo nala upgrade'
        alias dist-sync='sudo nala update'
        alias show='nala show'

        function search()
        {
            nala list $@
        }
    else
        [[ $UID == 0 ]] && alias add='apt-get install' || alias add='sudo apt-get install'
        [[ $UID == 0 ]] && alias purge='apt-get autoremove' || alias purge='sudo apt-get autoremove'
        [[ $UID == 0 ]] && alias dist-upgrade='apt-get dist-upgrade' || alias dist-upgrade='sudo apt-get dist-upgrade'
        [[ $UID == 0 ]] && alias dist-sync='apt-get update' || alias dist-sync='sudo apt-get update'
        alias show='apt-cache show'

        function search()
        {
            apt-cache search --names-only $@ | sort
        }
    fi

    alias list='dpkg -L'

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

## Arch-based distros using yay package manager functions
elif which yay &> /dev/null
then
    alias add='yay -S'
    alias purge='yay -Rns'
    alias dist-upgrade='yay -Syu'
    alias search='yay -Ss'
    alias show='yay -Si'
    alias list='yay -Ql'

## Cygwin
elif [[ $OSTYPE == cygwin ]] && which apt-cyg &> /dev/null
then
    alias add='apt-cyg install'
    alias purge='apt-cyg remove'
    alias dist-upgrade='echo "Not implemented!"; false'
    alias dist-sync='apt-cyg update'
    alias search='apt-cyg search'
    alias show='apt-cyg show'
    alias list='apt-cyg listfiles'
fi

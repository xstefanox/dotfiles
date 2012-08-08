#!/bin/bash

## Enable colors on directory listing
if [[ $(uname -s) == Darwin ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l='ls -1'     # 1-column output
alias ll='ls -lh'   # show details, with size on human readable form
alias la='ls -alh'  # show hidden files

## Don't ping forever
alias ping='ping -c 3'

## Show human readable volume sizes
alias df='df -h'

## grep colored output
alias grep='grep --color -n'

## Nano
# - smooth scrolling
# - use the first line to show text
# - use spaces instead of tabs
# - don't wrap long lines
# - always show cursor position
# - use tabs instead of spaces
alias nano='nano --smooth --morespace --tabsize=4 --nowrap --const --tabstospaces'

## Diff
which diff &> /dev/null && alias diff='diff -Nur'
which colordiff &> /dev/null && alias colordiff='colordiff -Nur'

## Tail
which colortail &> /dev/null && alias tail='colortail'

## free (this command does not exist on Mac OSX, so check for its existence)
which free &> /dev/null && alias free='free -m'

## Skynet
# don't create these aliases on skynet itself
if [[ $(hostname) != skynet ]]
then
    alias skynet='ssh -p7777 root@$(ping -c1 -W1 skynet.local &> /dev/null && echo skynet.local || echo xstefanox.homelinux.org)'
    alias poweroff-skynet='ssh -p7777 root@$(ping -c1 -W1 skynet.local &> /dev/null && echo skynet.local || echo xstefanox.homelinux.org) poweroff'
    alias reboot-skynet='ssh -p7777 root@$(ping -c1 -W1 skynet.local &> /dev/null && echo skynet.local || echo xstefanox.homelinux.org) reboot'
fi

## MySQL
which mysql &> /dev/null && alias mysql='mysql --host=localhost --user=root'
which mysqldump &> /dev/null && alias mysqldump='mysqldump --host=localhost --user=root'
which mysqlimport &> /dev/null && alias mysqlimport='mysqlimport --host=localhost --user=root'

## Transmission
which transmission-remote &> /dev/null && alias tda='transmission-remote --add'
which transmission-remote &> /dev/null && alias tdl='transmission-remote --list'
which transmission-remote && function tdr()
{
    if [[ -n "$1" ]]
    then
        transmission-remote --torrent $1 --remove
    else
        echo "Please provide the torrent number"
        return 1
    fi
}

## Debian-based distros package manager functions
if [[ -e /etc/debian_version ]]
then
    alias search='apt-cache search --names-only'
    alias add='apt-get install'
    alias show='apt-cache show'
    alias purge='apt-get autoremove'
    alias dist-upgrade='apt-get dist-upgrade'
    alias dist-sync='apt-get update'
    alias list='dpkg -L'
## Fedora-based distros package manager functions
elif [[ -e /etc/fedora-release ]]
then
    alias search='yum search'
    alias add='[[ $UID == 0 ]] && yum install || sudo yum install'
    alias show='yum info'
    alias purge='[[ $UID == 0 ]] && yum erase || sudo yum erase'
    alias dist-upgrade='[[ $UID == 0 ]] && yum upgrade || sudo yum upgrade'
    alias dist-sync='yum check-update'
    alias list='repoquery --list'
fi

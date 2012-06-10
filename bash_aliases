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
alias nano='nano --smooth --morespace --tabsize=4 --nowrap --const'

## Skynet
alias skynet='ssh -p7777 root@xstefanox.homelinux.org'
alias poweroff-skynet='ssh -p7777 root@xstefanox.homelinux.org poweroff'
alias reboot-skynet='ssh -p7777 root@xstefanox.homelinux.org reboot'

## MySQL
which mysql &> /dev/null && alias mysql='mysql --host=localhost --user=root'
which mysqldump &> /dev/null && alias mysqldump='mysqldump --host=localhost --user=root'
which mysqlimport &> /dev/null && alias mysqlimport='mysqlimport --host=localhost --user=root'

## Transmission
which transmission-remote &> /dev/null && alias tda='transmission-remote --add'
which transmission-remote &> /dev/null && alias tdl='transmission-remote --list'

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
    alias add='yum install'
    alias show='yum info'
    alias purge='yum erase'
    alias dist-upgrade='yum upgrade'
#    alias dist-sync='apt-get update'   # this is handled automatically by yum
    alias list='repoquery --list'
fi

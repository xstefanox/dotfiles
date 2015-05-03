#!/bin/bash

##########
## RUBY ##
##########

# add user home installed gems binary path to the PATH
if which gem &> /dev/null
then
    export PATH="$(gem env | sed -n '/GEM PATHS/,/GEM/ p' | grep "${HOME}" | sed -e "s:.*\(${HOME}.*\):\1:" -e "s:.*:&/bin:" | paste -s -d':' -)/bin:${PATH}"
fi

#########
## RVM ##
#########

if [[ -d "${HOME}/.rvm" ]]
then
    PATH=$HOME/.rvm/bin:$PATH
    [[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
fi

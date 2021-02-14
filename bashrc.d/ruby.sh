#!/bin/bash

#########
## RVM ##
#########

if [[ -f "${HOME}/.rvm/scripts/rvm"  ]]
then
    source "${HOME}/.rvm/scripts/rvm"
fi

##########
## RUBY ##
##########

# add user home installed gems binary path to the PATH
if which gem &> /dev/null
then
    export PATH="$(gem env | sed -n '/GEM PATHS/,/GEM/ p' | grep "${HOME}" | sed -e "s:.*\(${HOME}.*\):\1:" | paste -s -d':' -)/bin:${PATH}"
fi

#!/bin/bash

#########
## RVM ##
#########

source "${HOME}/.rvm/scripts/rvm"

##########
## RUBY ##
##########

# add user home installed gems binary path to the PATH
if which gem &> /dev/null
then
    export PATH="$(gem env | sed -n '/GEM PATHS/,/GEM/ p' | grep "${HOME}" | sed -e "s:.*\(${HOME}.*\):\1:" | paste -s -d':' -)/bin:${PATH}"
fi

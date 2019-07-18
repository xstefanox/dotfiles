#!/bin/bash

############
## NODEJS ##
############

#if which npm &> /dev/null
#then
#    # set the correct paths to install global npm modules in user home
#    npm_config="$(< ${HOME}/.npmrc)"
#    echo "$npm_config" | grep -q "prefix=${HOME}/.npm/packages" || npm config set prefix ~/.npm/packages
#    echo "$npm_config" | grep -q "cache=${HOME}/.npm/cache" || npm config set cache ~/.npm/cache
#    echo "$npm_config" | grep -q "progress=false" || npm config set progress false
#    unset npm_config
#
#    # add the npm binary path to the PATH
#    PATH=$HOME/.npm/packages/bin:$PATH
#
#    NODE_PATH=$NODE_PATH:/home/xstefanox/.npm/packages/lib/node_modules
#fi

if which yarn &> /dev/null
then
    PATH=$HOME/.yarn/bin:$PATH
fi

if [[ -e "${NVM_HOME}/nvm.sh" ]]
then
    . "${NVM_HOME}/nvm.sh"
fi

#!/bin/bash

############
## NODEJS ##
############

# switching to NVM, this is temporarily commented out, waiting for removal

#if which npm &> /dev/null
#then
#    # set the correct paths to install global npm modules in user home
#    npm config set prefix ~/.npm/packages
#    npm config set cache ~/.npm/cache
#
#    # add the npm binary path to the PATH
#    PATH=$HOME/.npm/packages/bin:$PATH
#
#    NODE_PATH=$NODE_PATH:/home/xstefanox/.npm/packages/lib/node_modules
#fi

# put NVM in the use home
export NVM_DIR="${HOME}/.nvm"

if [[ -e "${HOME}/.local/opt/dotfiles/submodules/nvm/nvm.sh" ]]
then
    # load NVM
    . "${HOME}/.local/opt/dotfiles/submodules/nvm/nvm.sh"
fi


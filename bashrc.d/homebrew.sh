#!/bin/bash

##############
## HOMEBREW ##
##############

# add the Homebrew PATH
if [[ $OSTYPE == darwin* && -d "$HOME/Library/Homebrew" ]]
then
    export PATH=$HOME/Library/Homebrew/bin:$PATH
    export PATH=$HOME/Library/Homebrew/sbin:$PATH

    # PHP 5.6 support
    [[ ! -f "${HOME}/.brew-prefix-php56" ]] && brew --prefix homebrew/php/php56 > "${HOME}/.brew-prefix-php56"
    export PATH="$(< ${HOME}/.brew-prefix-php56)/bin:$PATH"
fi

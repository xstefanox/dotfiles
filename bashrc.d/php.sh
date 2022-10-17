#!/bin/bash

#########
## PHP ##
#########

# Composer: add user packages bin directory to the PATH
PATH=$HOME/.composer/vendor/bin:$PATH

# PHPBrew
[[ -e ~/.phpbrew ]] && source ~/.phpbrew/bashrc

if [[ $OSTYPE == darwin* && -n "$BREW_PREFIX" ]]
then
    # use the latest version as default
    export PATH="$BREW_PREFIX/opt/php/bin:$PATH"
        
    function pvm() {
        local version=$1

        export PATH="$BREW_PREFIX/opt/php@${version}/bin:$PATH"
        export PATH="$BREW_PREFIX/opt/php@${version}/sbin:$PATH"
    }

    complete -W "$(find ${BREW_PREFIX}/opt -name php@* | cut -d@ -f2 | tr \\n ' ')" pvm
fi

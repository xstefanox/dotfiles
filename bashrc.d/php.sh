#!/bin/bash

#########
## PHP ##
#########

# Pear
[[ $UID != 0 ]] && alias pear='sudo pear'
[[ $UID != 0 ]] && alias pecl='sudo pecl'

# Composer: add user packages bin directory to the PATH
PATH=$HOME/.composer/vendor/bin:$PATH

# PHPBrew
[[ -e ~/.phpbrew ]] && source ~/.phpbrew/bashrc

# XDebug
alias xdebug-on='export XDEBUG_CONFIG="remote_enable=1"'
alias xdebug-off='export XDEBUG_CONFIG="remote_enable=0"'

# XDebug is disabled by default
export XDEBUG_CONFIG="remote_enable=0"

# modules
if [[ $UID != 0 ]]
then
    which php5enmod &> /dev/null && alias php5enmod='sudo php5enmod'
    which php5dismod &> /dev/null && alias php5dismod='sudo php5dismod'
fi

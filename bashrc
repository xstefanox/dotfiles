#!/bin/bash

##################
## BASH OPTIONS ##
##################

# Fix cd typos
shopt -s cdspell

# Treat undefined variables as errors
#set -o nounset

# Don't attempt to search the PATH for possible completions when completion is called on an empty line
shopt -s no_empty_cmd_completion

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

###########################
## ENVIRONMENT VARIABLES ##
###########################

for env_module in `find "${HOME}/.env.d" \( -type f -o -type l \) -name '*.sh' | sort`
do
    source "$env_module"
done

unset env_module

####################
## BASHRC MODULES ##
####################

for bashrc_module in `find "${HOME}/.bashrc.d" \( -type f -o -type l \) -name '*.sh' | sort`
do
    source "$bashrc_module"
done

unset bashrc_module

#####################
## BASH COMPLETION ##
#####################

if [[ $OSTYPE == darwin* ]]
then
    if [[ -n "$BREW_PREFIX" && -r "${BREW_PREFIX}/etc/bash_completion.d" ]]
    then
        for brew_completion in $(find ${BREW_PREFIX}/etc/bash_completion.d -type f -o -type l)
        do
            source $brew_completion
        done
    fi
else
    if [[ -f /etc/bash_completion ]] && ! shopt -oq posix
    then
        source /etc/bash_completion
    fi
fi

for bash_completion_module in `find "${HOME}/.bash_completion.d" \( -type f -o -type l \) -name '*.sh' | sort`
do
    source "$bash_completion_module"
done

unset bash_completion_module

# TAB-completion for sudo
complete -cf sudo

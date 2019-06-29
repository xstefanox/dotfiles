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

####################
## BASHRC MODULES ##
####################

## execute each bashrc module
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
    if which brew &> /dev/null
    then
        source "$(brew --prefix)/completions/bash/brew"
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

# TAB-completion for sudo
complete -cf sudo

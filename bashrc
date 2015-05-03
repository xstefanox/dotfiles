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
        source "$(brew --prefix)/Library/Contributions/brew_bash_completion.sh"
    fi
else
    [[ -z "$BASH_COMPLETION" && -f /etc/bash_completion ]] && export BASH_COMPLETION=/etc/bash_completion
    [[ -z "$BASH_COMPLETION_DIR" && -f /etc/bash_completion.d ]] && export BASH_COMPLETION_DIR=/etc/bash_completion.d
    [[ -z "$BASH_COMPLETION_COMPAT_DIR" && -f /etc/bash_completion.d ]] && export BASH_COMPLETION_COMPAT_DIR=/etc/bash_completion.d
fi

# TAB-completion for sudo
complete -cf sudo

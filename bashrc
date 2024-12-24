#!/usr/bin/env bash

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

# system completions
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix
then
    source /etc/bash_completion
fi

dotfiles_path=$(dirname $(readlink $BASH_SOURCE))

# dotfiles completions
for bash_completion_module in $(find "${dotfiles_path}/bash_completion.d" \( -type f -o -type l \) -name '*.sh' | sort)
do
    source $bash_completion_module
done

# user completions
for bash_completion_module in `find "${HOME}/.bash_completion.d" \( -type f -o -type l \) -name '*.sh' | sort`
do
    source "$bash_completion_module"
done

unset bash_completion_module dotfiles_path

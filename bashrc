#!/usr/bin/env bash

###########
## SETUP ##
###########

function _list_modules() {
    local dot_dir=$1

    find "${dot_dir}" \( -type f -o -type l \) -name '*.sh' | sort
}

dotfiles_path=$(dirname $(readlink $BASH_SOURCE))

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

# dotfiles environment variables
for env_module in $(_list_modules ${dotfiles_path}/env.d)
do
    source "$env_module"
done

# user environment variables
for env_module in $(_list_modules ${HOME}/.env.d)
do
    source "$env_module"
done

unset env_module

####################
## BASHRC MODULES ##
####################

# dotfiles bashrc
for bashrc_module in $(_list_modules ${dotfiles_path}/bashrc.d)
do
    source "$bashrc_module"
done

# user bashrc
for bashrc_module in $(_list_modules ${HOME}/.bashrc.d)
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

# dotfiles completions
for bash_completion_module in $(_list_modules ${dotfiles_path}/bash_completion.d)
do
    source $bash_completion_module
done

# user completions
for bash_completion_module in $(_list_modules ${HOME}/.bash_completion.d)
do
    source "$bash_completion_module"
done

unset bash_completion_module

#############
## CLEANUP ##
#############

unset dotfiles_path
unset _list_modules
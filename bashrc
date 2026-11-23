#!/usr/bin/env bash

#################
## INTERACTIVE ##
#################

# This file is also read by Bash in some non-interactive cases (e.g. "ssh host command"):
# in that case do nothing, because the following configuration is meant for interactive shells only
if [[ $- != *i* ]]
then
    return
fi

###########
## SETUP ##
###########

# find the dotfiles directory through the symlink of this file
_bashrc_dir=$(dirname "$(readlink "${BASH_SOURCE[0]}")")

if [[ "$_bashrc_dir" == "." ]]
then
    _bashrc_dir=$(dirname "${BASH_SOURCE[0]}")
fi

# shared helpers (DOTFILES_PATH, _list_modules, path_prepend, reload-env)
source "${_bashrc_dir}/dotfiles.sh"

unset _bashrc_dir

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

# dotfiles bashrc
_source_modules "${DOTFILES_PATH}/bashrc.d"

# user bashrc
_source_modules "${HOME}/.bashrc.d"

#####################
## BASH COMPLETION ##
#####################

# system completions
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix
then
    source /etc/bash_completion
fi

# dotfiles completions
_source_modules "${DOTFILES_PATH}/bash_completion.d"

# user completions
_source_modules "${HOME}/.bash_completion.d"

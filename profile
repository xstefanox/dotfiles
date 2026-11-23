#!/bin/sh

#--------------------------------------
# Bash initialization
#
# LOGIN:
# /etc/profile
#     /etc/profile.env (if exists)
#     /etc/bash/bashrc (if exists)
#     /etc/profile.d/*.sh (if exists)
#
# ~/.bash_profile
#     /etc/bashrc
#     ~/.bashrc (if exists)
# if( ~/.bash_profile doesn't exist)
#     ~/.bash_login
# if( ~/.bash_profile doesn't exist)
#     ~/.bash_login
#
# NON-LOGIN
# /etc/bash/bashrc
# ~/.bashrc
#--------------------------------------

export GTK_THEME=Mint-Y-Dark-Aqua

# load the environment modules: this must happen before the interactivity check below,
# because the display manager reads this file in a non-interactive shell to set up the graphical session
if [ -n "$BASH_VERSION" ]
then
    # find the dotfiles directory through the symlink of this file
    _profile_dir=$(dirname "$(readlink "${BASH_SOURCE[0]}")")

    if [[ "$_profile_dir" == "." ]]
    then
        _profile_dir=$(dirname "${BASH_SOURCE[0]}")
    fi

    source "${_profile_dir}/dotfiles.sh"
    reload-env

    unset _profile_dir
fi

# if not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# if running Bash
if [[ -n "$BASH" ]]
then

    # execute each profile module
    for profile_module in `find "${HOME}/.profile.d" \( -type f -o -type l \) -name '*.sh' | sort`
    do
        source "$profile_module"
    done

    # include .bashrc if it exists
    if [[ -f ~/.bashrc ]]
    then
        . ~/.bashrc
    fi
fi

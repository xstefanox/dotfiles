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

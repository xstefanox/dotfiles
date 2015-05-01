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

    # define the path to the profile modules directory
    profile_modules_dir=~/.profile.d

    # ensure profile_modules_dir exists
    [[ ! -d "$profile_modules_dir" ]] && mkdir -p "$profile_modules_dir"

    # execute each bashrc script
    for profile_module in `find /home/xstefanox/.profile.d/ -type f -name '*.sh' | sort`
    do
        source "$profile_module"
    done

    # cleanup
    unset profile_module profile_modules_dir

    # determine the OS name
    export OS=`uname -s`

    # include .bashrc if it exists
    if [[ -f ~/.bashrc ]]
    then
        . ~/.bashrc
    fi
fi

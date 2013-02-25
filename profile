#!/bin/sh

#--------------------------------------
# Bash initialization
#
# LOGIN:
# /etc/profile
# 	/etc/profile.env (if exists)
# 	/etc/bash/bashrc (if exists)
# 	/etc/profile.d/*.sh (if exists)
#
# ~/.bash_profile
# 	/etc/bashrc
# 	~/.bashrc (if exists)
# if( ~/.bash_profile doesn't exist)
# 	~/.bash_login
# if( ~/.bash_profile doesn't exist)
# 	~/.bash_login
#
# NON-LOGIN
# /etc/bash/bashrc
# ~/.bashrc
#--------------------------------------

# if running Bash
if [[ -n "$BASH" ]]
then
    # include .bashrc if it exists
    if [[ -f ~/.bashrc ]]
    then
        . ~/.bashrc
    fi
fi


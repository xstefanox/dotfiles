#!/bin/sh

#--------------------------------------
# Login shell initialization
#
# This file is also read by the display manager to set up the graphical session, in a non-interactive shell.
#
#   1. environment modules (env.d): loaded by every login shell, interactive or not
#   2. if the shell is interactive: profile modules (~/.profile.d), then ~/.bashrc
#
# Outside of the Bash-only blocks keep the syntax POSIX, because other shells may read this file.
#--------------------------------------

# load the environment modules: this must happen before the interactivity check below,
# because the display manager reads this file in a non-interactive shell to set up the graphical session
if [ -n "$BASH_VERSION" ]
then
    # find the dotfiles directory through the symlink of this file
    _profile_dir=$(dirname "$(readlink "${BASH_SOURCE[0]}")")

    if [ "$_profile_dir" = "." ]
    then
        _profile_dir=$(dirname "${BASH_SOURCE[0]}")
    fi

    source "${_profile_dir}/dotfiles.sh"
    reload-env

    unset _profile_dir
fi

# if not running interactively, don't do anything
if [ -z "$PS1" ]
then
    return
fi

# if running Bash
if [ -n "$BASH_VERSION" ]
then
    # execute each profile module
    for profile_module in $(_list_modules "${HOME}/.profile.d")
    do
        source "$profile_module"
    done

    unset profile_module

    # include .bashrc if it exists
    if [ -f ~/.bashrc ]
    then
        . ~/.bashrc
    fi
fi

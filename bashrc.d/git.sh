#!/bin/bash

#########
## GIT ##
#########

function apply-preferences-git()
{
  if which git &> /dev/null
  then

    # include the versioned Git configuration
    git config --global include.path '~/.gitconfig.global'

    # disabled on OSX: this creates a daemon and a warning is always raised when closing the terminal
    if [[ $OSTYPE != darwin* ]]
    then
        git config --global credential.helper cache
    fi

    git config --global color.status.added     "green $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.status.changed   "yellow $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.status.untracked "red $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.status.unmerged  "red $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.diff.meta "blue $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.diff.frag "magenta $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.diff.old  "red $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.diff.new  "green $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.branch.current  "green $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"
    git config --global color.branch.remote   "red $([[ $OSTYPE == linux* || $OSTYPE == cygwin ]] && echo bold)"

  else
    echo "!!! git not found in PATH"
  fi
}

#!/bin/bash

#########
## GIT ##
#########

if which git &> /dev/null
then
    # include the versioned Git configuration
    git config --global include.path '~/.gitconfig.global'

    # disabled on OSX: this creates a daemon and a warning is always raised when closing the terminal
    if [[ $OSTYPE != darwin* ]]
    then
        git config --global credential.helper cache
    fi

    git config --global color.ui true
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

    git config --global core.excludesfile "~/.gitignore.global"
    git config --global push.default $(git --version | grep --silent " 1.8" && echo simple || echo matching)

    # @see https://gist.github.com/unphased/5303697
    git config --global alias.plog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%an <%ae>%Creset' --abbrev-commit --date=relative"
    git config --global alias.s status

    git config --global tag.sort version:refname

    git config --global pager.log  'diff-highlight | less'
    git config --global pager.show 'diff-highlight | less'
    git config --global pager.diff 'diff-highlight | less'
fi

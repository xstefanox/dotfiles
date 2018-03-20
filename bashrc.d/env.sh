#!/bin/bash

##########
## PATH ##
##########

## home binary path
export PATH="$HOME/.local/bin:$PATH"

## WII hd mount point
if [[ $OSTYPE == darwin* ]]
then
  export PATH=/Volumes/WII/bin:$PATH
else
  export PATH=/media/WII/bin:$PATH
fi

## Heroku binary path
if [[ -d "/usr/local/heroku" ]]
then
    PATH="/usr/local/heroku/bin:$PATH"
fi

## Packer binaries installed in HOME (there is no installer or package yet)
if [[ -d "${HOME}/.local/opt/packer" ]]
then
    PATH="${HOME}/.local/opt/packer:${PATH}"
fi

############
## EDITOR ##
############

if [[ $OSTYPE == darwin* ]]
then
    if which mate &> /dev/null
    then
        export EDITOR="mate -w"
    else
        export EDITOR=nano
    fi
elif [[ -n "$DISPLAY" ]]
then
    if which mousepad &> /dev/null
    then
        export EDITOR=mousepad
    elif which geany &> /dev/null
    then
        export EDITOR=geany
    elif which gedit &> /dev/null
    then
        export EDITOR=gedit
    fi
else
    export EDITOR=nano
fi

###########
## PAGER ##
###########

if which most &> /dev/null
then
    export PAGER=most
elif which less &> /dev/null
then
    export PAGER=less
fi

export LESS="--RAW-CONTROL-CHARS"

##########
## TERM ##
##########

if [[ "${TERM}" == xterm ]]
then
    TERM=xterm-256color
fi

##########
## MISC ##
##########

## Maximum allowed file size on a FAT32 filesystem
export FAT32_MAX_FILE_SIZE="$((2**32 - 1))"

## Size of a Nintendo WII ISO image
export WII_ISO_SIZE="4699979776"

## make history ignore commands starting with a space
export HISTIGNORE=' *'

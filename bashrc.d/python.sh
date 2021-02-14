#!/bin/bash

############
## PYTHON ##
############

export PYTHONPATH27=$HOME/.eggs/2.7/site-packages
export PYTHONPATH37=$HOME/.eggs/3.7/site-packages
export PYTHONPATH38=$HOME/.eggs/3.8/site-packages
export PYTHONPATH39=$HOME/.eggs/3.9/site-packages
export PYTHONBINPATH27=$PYTHONPATH27/bin
export PYTHONBINPATH37=$PYTHONPATH37/bin
export PYTHONBINPATH38=$PYTHONPATH38/bin
export PYTHONBINPATH39=$PYTHONPATH39/bin

export PATH=$PYTHONBINPATH39:$PYTHONBINPATH38:$PYTHONBINPATH37:$PYTHONBINPATH27:$PATH
export PYTHONPATH=$PYTHONPATH39:$PYTHONPATH38:$PYTHONPATH37:$PYTHONPATH27:$PYTHONPATH

# make pip use the default paths and install every egg into the user home

function pip27()
{
    if [[ $1 == install ]]
    then
        pip $@  --only-binary=:all: --python-version 27 --target $PYTHONPATH27
    else
        pip $@
    fi
} && export -f pip27

function pip37()
{
    if [[ $1 == install ]]
    then
        pip3 $@ --only-binary=:all: --python-version 37 --target $PYTHONPATH37
    else
        pip3 $@
    fi
} && export -f pip37

function pip38()
{
    if [[ $1 == install ]]
    then
        pip3 $@ --only-binary=:all: --python-version 38 --target $PYTHONPATH38
    else
        pip3 $@
    fi
} && export -f pip38

function pip39()
{
    if [[ $1 == install ]]
    then
        pip3 $@ --only-binary=:all: --python-version 39 --target $PYTHONPATH39
    else
        pip3 $@
    fi
} && export -f pip39

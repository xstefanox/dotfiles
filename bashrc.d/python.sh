#!/bin/bash

############
## PYTHON ##
############

# don't use the bloated easy_install
alias easy_install='echo "!!! Deprecated"; false'
alias easy_install-2.5='echo "!!! Deprecated"; false'
alias easy_install-2.6='echo "!!! Deprecated"; false'
alias easy_install-2.7='echo "!!! Deprecated"; false'
alias easy_install3='echo "!!! Deprecated"; false'
alias easy_install-3.3='echo "!!! Deprecated"; false'

export PYTHONSTARTUP=$HOME/.pythonrc
export PYTHONHISTORY=$HOME/.python_history
export PYTHONPATH27=$HOME/.eggs/2.7/site-packages
export PYTHONPATH33=$HOME/.eggs/3.3/site-packages
export PYTHONBINPATH27=$PYTHONPATH27/bin
export PYTHONBINPATH33=$PYTHONPATH33/bin
export PATH=$PYTHONBINPATH33:$PYTHONBINPATH27:$PATH
export PYTHONPATH=$PYTHONPATH33:$PYTHONPATH27:$PYTHONPATH

# make pip use the default paths and install every egg into the user home

which pip &> /dev/null && function pip()
{
    pip=`which pip`

    if [[ $1 == install ]]
    then
        $pip $@ --install-option="--install-purelib=$PYTHONPATH27" --install-option="--install-platlib=$PYTHONPATH27" --install-option="--prefix=$PYTHONPATH27"
    else
        $pip $@
    fi
} && export -f pip

which pip3 &> /dev/null && function pip3()
{
    pip3=`which pip3`

    if [[ $1 == install ]]
    then
        $pip3 $@ --install-option="--install-purelib=$PYTHONPATH33" --install-option="--install-platlib=$PYTHONPATH33" --install-option="--prefix=$PYTHONPATH33"
    else
        $pip3 $@
    fi
} && export -f pip3

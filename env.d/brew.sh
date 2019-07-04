if [[ $OSTYPE == darwin* ]]
then

    BREW_PREFIX=$HOME/Library/Homebrew

    if [[ -d "$BREW_PREFIX" ]]
    then
        export PATH=$BREW_PREFIX/bin:$PATH
        export PATH=$BREW_PREFIX/sbin:$PATH
    else
        unset BREW_PREFIX
    fi
fi

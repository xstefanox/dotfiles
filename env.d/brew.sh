if [[ $OSTYPE == darwin* ]]
then

    export BREW_PREFIX=$HOME/.local/opt/homebrew

    if [[ -d "$BREW_PREFIX" ]]
    then
        export PATH=$BREW_PREFIX/bin:$PATH
        export PATH=$BREW_PREFIX/sbin:$PATH
        export HOMEBREW_NO_ENV_HINTS=true
        export HOMEBREW_NO_AUTO_UPDATE=true
    else
        unset BREW_PREFIX
    fi
fi

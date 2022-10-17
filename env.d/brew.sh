if [[ $OSTYPE == darwin* ]]
then
    export BREW_PREFIX=/usr/local
    export HOMEBREW_NO_ENV_HINTS=true
    export HOMEBREW_NO_AUTO_UPDATE=true
    export HOMEBREW_CASK_OPTS="--no-quarantine"
fi

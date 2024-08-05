if [[ $OSTYPE == darwin* ]]
then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    if [ ! -z "${MANPATH-}" ]
    then
        export MANPATH=":${MANPATH#:}";
    fi
    export HOMEBREW_NO_ENV_HINTS=true
    export HOMEBREW_NO_AUTO_UPDATE=true
    export HOMEBREW_CASK_OPTS="--no-quarantine"
fi

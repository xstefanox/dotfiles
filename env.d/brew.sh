if [[ $OSTYPE == darwin* ]]
then
    LOCAL_HOMEBREW_PATH=${HOME}/.local/opt/homebrew

    if [[ -d ${LOCAL_HOMEBREW_PATH} ]]
    then
        export PATH="${LOCAL_HOMEBREW_PATH}/bin:${LOCAL_HOMEBREW_PATH}/sbin${PATH+:$PATH}"
        export INFOPATH="${LOCAL_HOMEBREW_PATH}/share/info:${INFOPATH:-}";
    fi

    if which brew &> /dev/null
    then
        eval "$(brew shellenv)"

        if [ ! -z "${MANPATH-}" ]
        then
            export MANPATH=":${MANPATH#:}";
        fi

        export HOMEBREW_NO_ENV_HINTS=true
        export HOMEBREW_NO_AUTO_UPDATE=true
        export HOMEBREW_CASK_OPTS="--no-quarantine --appdir=${HOME}/Applications --fontdir=${HOME}/Library/Fonts"
    fi

    unset LOCAL_HOMEBREW_PATH
fi

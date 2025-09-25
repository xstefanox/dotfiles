if [[ $OSTYPE == darwin* ]]
then
    HOMEBREW_PATH_HOME=${HOME}/.local/opt/homebrew
    HOMEBREW_PATH_OPT=/opt/homebrew
    HOMEBREW_PATH=$([[ -e "${HOMEBREW_PATH_HOME}" ]] && echo "${HOMEBREW_PATH_HOME}" || echo "${HOMEBREW_PATH_OPT}")
    HOMEBREW_BIN=${HOMEBREW_PATH}/bin/brew

    if [[ -e "${HOMEBREW_BIN}" ]]
    then
        eval "$($HOMEBREW_BIN shellenv)"
        export HOMEBREW_NO_ENV_HINTS=true
        export HOMEBREW_NO_AUTO_UPDATE=true
        export HOMEBREW_CASK_OPTS="--no-quarantine --appdir=${HOME}/Applications --fontdir=${HOME}/Library/Fonts"
    fi

    unset HOMEBREW_PATH HOMEBREW_PATH_HOME HOMEBREW_PATH_OPT HOMEBREW_BIN
fi

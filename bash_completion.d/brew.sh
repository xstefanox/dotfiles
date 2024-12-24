#!/usr/bin/env bash

if [[ -e "${HOMEBREW_PREFIX}" ]]
then
    MODULES=(
        brew
        certigo
        git-completion.bash
        poetry
        rye
        uv
        uvx
    )

    for MODULE in ${MODULES[*]}
    do
        MODULE="${HOMEBREW_PREFIX}/etc/bash_completion.d/${MODULE}"

        if [[ -e "${MODULE}" ]]
        then
            source "${MODULE}"
        fi
    done

    unset MODULE MODULES
fi

#!/usr/bin/env bash

# Helpers shared by profile and bashrc: this file is meant to be sourced, not executed.
# Keep it compatible with Bash 3.2 (the default one on macOS) and with Bash running in POSIX mode.

#######################
## DOTFILES LOCATION ##
#######################

# Absolute path of the dotfiles repository, computed from the real location of this file
_dotfiles_source=${BASH_SOURCE[0]}

while [[ -L "${_dotfiles_source}" ]]
do
    _dotfiles_link=$(readlink "${_dotfiles_source}")

    case "${_dotfiles_link}" in
        /*)
            _dotfiles_source=${_dotfiles_link}
            ;;
        *)
            _dotfiles_source=$(dirname "${_dotfiles_source}")/${_dotfiles_link}
            ;;
    esac
done

DOTFILES_PATH=$(cd "$(dirname "${_dotfiles_source}")" && pwd -P)

unset _dotfiles_source _dotfiles_link

###############
## FUNCTIONS ##
###############

# Print the shell modules (*.sh) in the given directory, sorted by name
function _list_modules()
{
    local dot_dir=$1

    if [[ -d "${dot_dir}" ]]
    then
        find "${dot_dir}" \( -type f -o -type l \) -name '*.sh' | sort
    fi
}

# Source all the shell modules (*.sh) in the given directory, sorted by name.
# The list is read from file descriptor 3, so that the modules cannot consume it through the standard input
function _source_modules()
{
    local modules_dir=$1
    local module_file

    while IFS= read -r -u 3 module_file
    do
        if [[ -n "${module_file}" ]]
        then
            source "${module_file}"
        fi
    done 3<<< "$(_list_modules "${modules_dir}")"
}

# Put the given directory at the front of PATH, removing any other occurrence of it:
# this keeps PATH free of duplicates even if the environment modules are loaded more than once
function path_prepend()
{
    local dir=$1
    local entry
    local new_path=$dir
    local old_ifs=$IFS

    IFS=:

    for entry in $PATH
    do
        if [[ -n "${entry}" && "${entry}" != "${dir}" ]]
        then
            new_path=${new_path}:${entry}
        fi
    done

    IFS=$old_ifs

    export PATH=$new_path
}

# Load again the environment modules, to apply the changes made to them without opening a new login shell
function reload-env()
{
    _source_modules "${DOTFILES_PATH}/env.d"
    _source_modules "${HOME}/.env.d"
}

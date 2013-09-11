#!/bin/bash


# get a reference to the repository path
declare -r REPO_PATH="$(dirname $0)"

# get a reference to this script
declare -r BOOTSTRAP="$(basename $0)"

function do_symlink()
{
    local label=$0
    local target=$1
    local name=$2
    
    echo -n " * Installing ${d}..."
    rm -rf "${symlink_name}" && ln -s -f "${symlink_target}" "${symlink_name}"
    echo "Done"
}

function readlink()
{
    if [[ $(uname -s) == Darwin ]] && which greadlink &> /dev/null
    then
        greadlink $@
     else
        $(which readlink) $@
    fi
}

function bootstrap_dir()
{
    local base_path=$1
    
    # find the installable files, discarding bootstrap itself, any readme files and executable files;
    # the result should be a reasonable set of dotfiles
    local dotfiles=$(find "${base_path}" -maxdepth 1 -type f -not -name "${BOOTSTRAP}" -not -name 'README*' -not -perm +0111 -exec basename {} \;)
    
    # report the list of dotfiles
    echo
    echo "The following dotfiles will be installed through a symlink to the repository (${base_path}):"
    echo
    echo "${dotfiles}" | sed 's:.*: * &:'
    echo
    echo -n "Proceed? [Yn]: "

    read proceed

    [[ "${proceed}" != Y && "${proceed}" != "" ]] && exit 0
    
    for d in $dotfiles
    do
        # determine the symlink target
        symlink_target="$(readlink -e "${base_path}/${d}")"
        
        # determine the symlink name
        symlink_name="${HOME}/$([[ "${base_path}" == "${REPO_PATH}" ]] && echo . || echo ".${base_path/.\//}/")${d}"
        
        # check if the current file is a symlink
        is_link="$([[ -L "${symlink_name}" ]] && echo true || echo false)"
        current_symlink_target="$($is_link && readlink -e "${symlink_name}")"
        is_broken_link="$($is_link && ! readlink -e "${symlink_name}" &> /dev/null && echo true || echo false)"
        is_dotfile_link="$(! $is_broken_link && [[ "${current_symlink_target}" == "${symlink_target}" ]] && echo true || echo false)"
        
        # check if the current file exists
        is_file="$([[ -f "${symlink_name}" ]] && ! $is_link && echo true || echo false)"
        is_dir="$([[ -d "${symlink_name}" ]] && echo true || echo false)"
        
        # if the symlink exists
        if $is_dotfile_link
        then
            # do nothing
            echo " * Already installed: ${d}"
        # if the file exists or is a link pointing to something else or is a broken link
        elif [[ -e "${symlink_name}" ]] || $is_dotfile_link || $is_broken_link
        then
            # ask the user what to do
            unset op
            while [[ "${op}" == "" ]] || ! echo "${op}" | grep --ignore-case --quiet "^[OSQ]$"
            do
                echo -n " * Link target for ${d} exists ("
                $is_file && echo -n "file, $(du -sh "${symlink_name}" | cut -d$'\t' -f1)"
                $is_dir && echo -n "directory, $(du -sh "${symlink_name}" | cut -d$'\t' -f1), $(find "${symlink_name}" | wc -l) files or directories"
                $is_link && ! $is_broken_link && echo -n "symbolic link to $(readlink ${symlink_name})"
                $is_broken_link && echo -n "broken link to $(readlink ${symlink_name})"
                echo -n "). What do you want to do? [Overwrite,Skip,Quit]: "
                read op
            done
            
            case "${op}" in
            
                [sS])
                    # do nothing
                    echo " * Skipping ${d}"
                    ;;
                
                [qQ])
                    # abort the installation
                    exit 0
                    ;;
                
                [oO])
                    # overwrite the existing target
                    do_symlink "${d}" "${symlink_target}" "${symlink_name}"
                    ;;
            
            esac
            
        # if the symlink does not exist
        else
            # create it
            do_symlink "${d}" "${symlink_target}" "${symlink_name}"
        fi
    done
}

bootstrap_dir "${REPO_PATH}"
bootstrap_dir "${REPO_PATH}/js"


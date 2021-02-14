#!/bin/bash

#######################################
## MISCELLANEOUS FUNCTIONS & ALIASES ##
#######################################

# @see http://vpalos.com/537/uri-parsing-using-bash-built-in-features/
#
# URI parsing function
#
# The function creates global variables with the parsed results.
# It returns 0 if parsing was successful or non-zero otherwise.
#
# [schema://][user[:password]@]host[:port][/path][?[arg1=val1]...][#fragment]
#
# @param $1 uri
# @return array
#
function parse_uri()
{
    local pattern
    local uri
    local uri_schema
    local uri_address
    local uri_user
    local uri_password
    local uri_host
    local uri_port
    local uri_path
    local uri_query
    local uri_fragment
    local count
    local path

    pattern='^(([a-z]{3,5})://)?((([^:\/]+)(:([^@\/]*))?@)?([^:\/?]+)(:([0-9]+))?)(\/[^?]*)?(\?[^#]*)?(#.*)?$'

    # uri capture
    uri="$@"

    # safe escaping
    uri="${uri//\`/%60}"
    uri="${uri//\"/%22}"

    # top level parsing
    [[ "$uri" =~ $pattern ]] || return 1;

    # component extraction
    uri=${BASH_REMATCH[0]}
    uri_schema=${BASH_REMATCH[2]}
    uri_address=${BASH_REMATCH[3]}
    uri_user=${BASH_REMATCH[5]}
    uri_password=${BASH_REMATCH[7]}
    uri_host=${BASH_REMATCH[8]}
    uri_port=${BASH_REMATCH[10]}
    uri_path=${BASH_REMATCH[11]}
    uri_query=${BASH_REMATCH[12]}
    uri_fragment=${BASH_REMATCH[13]}

    # path parsing
    count=0
    path="$uri_path"
    pattern='^/+([^/]+)'
    while [[ $path =~ $pattern ]]; do
        eval "uri_parts[$count]=\"${BASH_REMATCH[1]}\""
        path="${path:${#BASH_REMATCH[0]}}"
        let count++
    done

    # query parsing
    count=0
    query="$uri_query"
    pattern='^[?&]+([^= ]+)(=([^&]*))?'
    while [[ $query =~ $pattern ]]; do
        eval "uri_args[$count]=\"${BASH_REMATCH[1]}\""
        eval "uri_arg_${BASH_REMATCH[1]}=\"${BASH_REMATCH[3]}\""
        query="${query:${#BASH_REMATCH[0]}}"
        let count++
    done

    # main uri
    echo "${uri}"

    # mai uri components
    echo "${uri_schema}"
    echo "${uri_address}"
    echo "${uri_user}"
    echo "${uri_password}"
    echo "${uri_host}"
    echo "${uri_port}"
    echo "${uri_path}"
    echo "${uri_query}"
    echo "${uri_fragment}"

    # return success
    return 0
}

export -f parse_uri

# @see http://www.linuxjournal.com/content/validating-ip-address-bash-script
#
# Test an IP address for validity:
# Usage:
#      valid_ip IP_ADDRESS
#      if [[ $? -eq 0 ]]; then echo good; else echo bad; fi
#   OR
#      if valid_ip IP_ADDRESS; then echo good; else echo bad; fi
#
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

export -f valid_ip

## Enable colors on directory listing
if [[ $OSTYPE == darwin* || $(uname -s) == FreeBSD ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l='ls -1'     # single-column output
alias ll='ls -lh'   # show details, with size in human readable form
alias la='ls -alh'  # show hidden files

## ping:
#- avoid endless ping
alias ping='ping -c 3'

## df:
#- show human readable volume sizes
alias df='df -h'

## grep:
#- colored output
alias grep='grep --color'

## diff
#- always show patch output style
#- use colors where possible

which colordiff &> /dev/null && alias colordiff='colordiff -Nur'

function diff()
{
    local cmd
    local item

    # check if we can use colored output
    if which colordiff &> /dev/null
    then
        cmd="colordiff -Nur"
    else
        cmd="diff -Nur"
    fi

    # append the quoted arguments to the command
    for item in $@
    do
        cmd+=" '${item}'"
    done

    # show word diff if diff-highlight (from Git) is installed
    # @see https://raw.github.com/git/git/master/contrib/diff-highlight/diff-highlight
    if which diff-highlight &> /dev/null
    then
        cmd+=" | diff-highlight"
    fi

    # execute the diff
    eval "$cmd"
}

## tail
#- use color where possible
which colortail &> /dev/null && alias tail='colortail'

## free
#- show size in MegaBytes
# (this command does not exist on Mac OSX, so check for its existence)
which free &> /dev/null && alias free='free -m'

## screen
alias screen='screen -RD'

## jobs
# -always show PIDs
alias jobs='jobs -pl'

## List all the open TCP or UDP ports on the machine
alias open-ports='nc -vz localhost 1-65535 2>&1 | $(which grep) -i succeeded'
alias connections='netstat -tulanp'

## show mounted silesystems in a human readable format
alias mounted='mount | column -t'

## show the current PATH in a human readable format
alias path='echo -e ${PATH//:/\\n}'

## a shortcut to purge directories
alias rimraf='rm -rf'

## simple line counter
alias wl='wc -l'

## A shortcut to open a file or a directory
if [[ $OSTYPE == darwin* ]]
then
    alias o='open'
else
    # on other Unix systems, check for an active X11 session
    [[ $OSTYPE == linux* ]] && [[ -n "$DISPLAY" ]] && alias o='gio open' || alias o='$EDITOR'
fi

## Baobab
which baobab &> /dev/null || alias baobab='find . -maxdepth 1 -type d -and -not -wholename . -print0 | sort -z | xargs -0 du -sh'

## Transmission
which transmission-remote &> /dev/null && alias tda='transmission-remote --add'
which transmission-remote &> /dev/null && alias tdl='transmission-remote --list'
which transmission-remote &> /dev/null && function tdr()
{
    if [[ -n "$1" ]]
    then
        transmission-remote --torrent $1 --remove
    else
        echo "Please provide the torrent number"
        return 1
    fi
}

## abcde
#- automatically unmount the inserted disc, without ejecting it
#- automatically determine the disc device
#- skip cddb query
[[ $OSTYPE == darwin* ]] && which abcde &> /dev/null && function rip()
{
    dev="$(mount | \grep cddafs | cut -d' ' -f1)"

    if [[ -n "$dev" ]]
    then
        # unmount the disc
        hdiutil unmount "$dev" -quiet && abcde -d "$dev" -N -a read,encode,move,clean
    fi
}

## Gitg
which gitg &> /dev/null && alias gitg='gitg &>/dev/null &'

## Gitk
which gitk &> /dev/null && alias gitk='gitk --all &'

## Password generator
function genpasswd()
{
    # exit if pwgen is not installed
    ! which pwgen &> /dev/null && echo "Error: pwgen not installed" && return 1

    # generate only one password, 8 character long, containing only lowercase chars
    pwgen --no-capitalize --numerals 8 1
}

## Check if a file can be written on a FAT32 partition
function is_FAT32_compliant()
{
    [[ $# == 0 ]] && echo "Usage: is_FAT32_compliant <filename>" && return 1
    local arg=$1

    # calcola la dimensione del file
    local size="$(stat -c %s "$arg")"

    # controlla se il file è più grande della dimensione massima consentita
    if [[ "$size" -le "$FAT32_MAX_FILE_SIZE" ]]
    then
        echo yes
        return 0
    else
        echo no
        return 1
    fi
}

## Compress, archive and split a file in parts that can be written on a FAT32 volume
function archive_file_for_FAT32()
{
    # exit if rar is not installed
    ! which rar &> /dev/null && echo "Error: rar not installed" && return 1

    # exit if no arguments given
    [[ $# == 0 ]] && echo "Usage: archive-file-for-FAT32 <filename>" && return 1

    # check if file exists
    local arg=$@
    [[ ! -f "${arg}" ]] && echo "File not found" && return 1

    # compress the file
    gzip -v -c -f "${arg}" > "${arg}.gz"
    arg="${arg}.gz"

    # split the file if needed
    local size="$(stat -c %s "$arg")"
    if is_FAT32_compliant "${arg}"
    then
        rar a -m0 -v${FAT32_MAX_FILE_SIZE}b "${arg}.rar" "${arg}"
    fi
}

## Remove the BOM from a file
function remove-bom()
{
    local f=$1

    if [[ ! -f ${f} ]]
    then
        echo 'No file given'
        return
    fi

    sed -i -e '1 s/^\xEF\xBB\xBF//' "${f}"
}

## Shortcut for editing text files
if [[ $OSTYPE == darwin* ]]
then
    alias edit='open -a TextMate'
fi

## Desktop notification
if [[ $OSTYPE == darwin* ]]
then
    if which growlnotify &> /dev/null
    then
        function notify()
        {
            growlnotify --appIcon "$([[ -n $3 ]] && echo $3)" --message "$1" "$2"
        }
        export -f notify
    fi
fi

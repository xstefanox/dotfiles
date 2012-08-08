#!/bin/bash

## List all the open TCP or UDP ports on the machine
alias open-ports='nc -vz localhost 1-65535 2>&1 | $(which grep) -i succeeded'

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
    if [[ $size -le $FAT32_MAX_FILE_SIZE ]]
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

## Calculate the space occupied by each subdirectory of the current directory
## @FIXME: not working if a subdirectory contains a space character
function baobab()
{
    for item in $(find . -maxdepth 1 -type d -and -not -wholename . -prune | sort)
    do
        du -sh $item
    done
}

## Show the man pages in the browser if a graphical session exists,
## otherwise in the existing pager, preferring 'most'
function man()
{
    local page=$1
    local category=
    
    # if a graphical session exists
    if [[ -n $DISPLAY ]]
    then
    
        # determine the language
        local lang=
        if [[ -n $LC_ALL ]]
        then
            lang=${LC_ALL:0:2}
        elif [[ -n $LANG ]]
        then
            lang=${LANG:0:2}
        else
            lang=en
        fi
        
        # determine the page and category
        if [[ ${page%.*} == ${page} ]]
        then
            category=man1
            page=${page}.1
        else
            category=man${page#*.}
        fi
        
        # open the page
        if [[ $(uname -s) == Darwin ]]
        then
            # on Mac OSX/Darwin
            open https://developer.apple.com/library/mac/#documentation/darwin/reference/manpages/${category}/${page}
        else
            # fallback on Ubuntu; try to select the release using lsb_release if possible
            xdg-open http://manpages.ubuntu.com/manpages/$(which lsb_release &> /dev/null && lsb_release --codename | cut -d$'\t' -f2)/en/${category}/${page} 2> /dev/null
        fi
        
    else
    
        # use the man binary (usually /usr/bin/man) and the preferred pager, if any (checking the $PAGER environment variable),
        # otherwise fallback on most, if it is installed, or less, which is tipically installed on any Unix system
        $(which man) $([[ -z $PAGER ]] && echo --pager=$(which most &> /dev/null && echo most || echo less)) $page
        
    fi
}

[[ $(uname -s) == Darwin ]] && which abcde &> /dev/null && function rip()
{
    dev="$(mount | \grep cddafs | cut -d' ' -f1)"
    
    if [[ -n "$dev" ]]
    then
        # unmount the disc
        hdiutil unmount "$dev" -quiet && abcde -d "$dev" -N -a read,encode,move,clean
    fi
}

## Git
## create the git-multistatus plugin if not found in the user path
if which git &> /dev/null && ! which git-multistatus &> /dev/null && [[ -n "$HOME_BIN" ]]
then

    cat << __EOF__ > "$HOME_BIN/git-multistatus"
#!/bin/bash
for item in *
do
    if [[ -d "\$item" ]]
    then
        cd "\$item"
        
        echo -e "\n##\${NO_COLOR} \$item"
        
        if [[ -z "\$(git status -s)" ]]
        then
            echo -e "\${GREEN}OK\${NO_COLOR}"
        else
            git status -s
        fi
        
        cd - &> /dev/null
    fi
done
__EOF__

    chmod +x "${HOME_BIN}/git-multistatus"
    
fi

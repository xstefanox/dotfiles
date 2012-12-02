#!/bin/bash

##################
## APPLICATIONS ##
##################

## Enable colors on directory listing
if osx
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l='ls -1'     # single-column output
alias ll='ls -lh'   # show details, with size on human readable form
alias la='ls -alh'  # show hidden files

## ping:
#- avoid endless ping
alias ping='ping -c 3'

## df:
#- show human readable volume sizes
alias df='df -h'

## grep:
#- colored output
alias grep='grep --color -n'

## nano
#- smooth scrolling
#- use the first line to show text
#- use spaces instead of tabs
#- don't wrap long lines
#- always show cursor position
#- use tabs instead of spaces
alias nano='nano --smooth --morespace --tabsize=4 --nowrap --const --tabstospaces'

## diff
#- always show patch output style
#- use colors where possible

which colordiff &> /dev/null && alias colordiff='colordiff -Nur'

function diff()
{
    if which colordiff &> /dev/null
    then
        colordiff $@
    else
        diff -Nur
    fi
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

## MySQL
which mysql &> /dev/null && alias mysql='mysql --host=localhost --user=root'
which mysqldump &> /dev/null && alias mysqldump='mysqldump --host=localhost --user=root'
which mysqlimport &> /dev/null && alias mysqlimport='mysqlimport --host=localhost --user=root'

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

## dpkg-based distros package manager functions
if which dpkg &> /dev/null
then
    alias search='apt-cache search --names-only'
    alias add='apt-get install'
    alias show='apt-cache show'
    alias purge='apt-get autoremove'
    alias dist-upgrade='apt-get dist-upgrade'
    alias dist-sync='apt-get update'
    alias list='dpkg -L'
## rpm-based distros using yum package manager functions
elif which yum &> /dev/null
then
    alias search='yum search'
    alias add='[[ $UID == 0 ]] && yum install || sudo yum install'
    alias show='yum info'
    alias purge='[[ $UID == 0 ]] && yum erase || sudo yum erase'
    alias dist-upgrade='[[ $UID == 0 ]] && yum upgrade || sudo yum upgrade'
    alias dist-sync='yum check-update'
    alias list='repoquery --list'
fi

## man
#- show the man pages in the browser if a graphical session exists,
#  otherwise in the existing pager, preferring 'most'
function man()
{
    local page=$1
    local category=
    
    # if a graphical session exists
    if [[ -n "$DISPLAY" ]]
    then
    
        # determine the language
        local lang=
        if [[ -n "$LC_ALL" ]]
        then
            lang=${LC_ALL:0:2}
        elif [[ -n $LANG ]]
        then
            lang=${LANG:0:2}
        else
            lang=en
        fi
        
        # determine the page and category
        if [[ "${page%.*}" == "${page}" ]]
        then
            category=man1
            page=${page}.1
        else
            category=man${page#*.}
        fi
        
        # open the page
        if osx
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
        $(which man) $([[ -z "$PAGER" ]] && echo --pager=$(which most &> /dev/null && echo most || echo less)) $page
        
    fi
}

## git
#- create the git-multistatus plugin if not found in the user path
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

## abcde
#- automatically unmount the inserted disc, without ejecting it
#- automatically determine the disc device
#- skip cddb query
osx && which abcde &> /dev/null && function rip()
{
    dev="$(mount | \grep cddafs | cut -d' ' -f1)"
    
    if [[ -n "$dev" ]]
    then
        # unmount the disc
        hdiutil unmount "$dev" -quiet && abcde -d "$dev" -N -a read,encode,move,clean
    fi
}

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

## Shortcut for editing text files
if osx
then
    alias edit='open -a TextMate'
fi

## Desktop notification
if osx
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

## Calculate the space occupied by each subdirectory of the current directory
## @FIXME: not working if a subdirectory contains a space character
#function baobab()
#{
#    for item in $(find . -maxdepth 1 -type d -and -not -wholename . -prune | sort)
#    do
#        du -sh $item
#    done
#}


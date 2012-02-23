## Calculate the space occupied by each subdirectory of the current directory
## FIXME: not working if a subdirectory contains a space character
alias baobab='for item in $(find . -maxdepth 1 -type d -and -not -wholename . -prune | sort); do du -sh $item; done;'

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
            # fallback on Ubuntu
            xdg-open http://manpages.ubuntu.com/manpages/$(lsb_release --codename | cut -d$'\t' -f2)/en/${category}/${page} 2> /dev/null
        fi
        
    else
    
        # use the man binary (usually /usr/bin/man) and the preferred pager, if any (checking the $PAGER environment variable),
        # otherwise fallback on most, if it is installed, or less, which is tipically installed on any Unix system
        $(which man) $([[ -z $PAGER ]] && echo --pager=$(which most &> /dev/null && echo most || echo less)) $page
        
    fi
}
export -f man

## List all the open TCP or UDP ports on the machine
alias open-ports='nc -vz localhost 1-65535 2>&1 | $(which grep) -i succeeded'

## Transmission
alias tda='transmission-remote --add'
alias tdl='transmission-remote --list'

## Debian-based distro specific functions
if [[ -e /etc/debian_version ]]
then
    alias search='apt-cache search --names-only'
    alias add='apt-get install'
    alias show='apt-cache show'
    alias purge='apt-get autoremove'
    alias dist-upgrade='apt-get dist-upgrade'
    alias dist-sync='apt-get update'
    alias list='dpkg -L'
fi

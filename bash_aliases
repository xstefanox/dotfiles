## Misc
# enable colors on directory listing
if [[ $(uname -s) == Darwin ]]
then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias l='ls -1'     # 1-column output
alias ll='ls -lh'   # show details, with size on human readable form
alias la='ls -alh'  # show hidden files
alias nano='nano --smooth --morespace --tabsize=4 --nowrap --const'
alias ping='ping -c 3'
alias df='df -h'

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
            # fallback on Ubuntu; try to select the release using lsb_release if possible
            xdg-open http://manpages.ubuntu.com/manpages/$(which lsb_release &> /dev/null && lsb_release --codename | cut -d$'\t' -f2)/en/${category}/${page} 2> /dev/null
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

# MySQL
which mysql &> /dev/null && alias mysql='mysql --host=localhost --user=root'
which mysqldump &> /dev/null && alias mysqldump='mysqldump --host=localhost --user=root'
which mysqlimport &> /dev/null && alias mysqlimport='mysqlimport --host=localhost --user=root'

## Transmission
which transmission-remote &> /dev/null && alias tda='transmission-remote --add'
which transmission-remote &> /dev/null && alias tdl='transmission-remote --list'

## Git
## create the git-multistatus plugin if not found in the user path
if which git &> /dev/null && ! which git-multistatus &> /dev/null
then
    
    IFS=$'\n'
    
    for path in $(echo $PATH | tr ':' '\n')
    do
        if [[ "${path/$HOME/}" != "$path" && -d "$path" ]]
        then
            cat << __EOF__ >> "${path}/git-multistatus"
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

            chmod +x "${path}/git-multistatus"
            
            break
        fi
    done
fi


## Debian-based distros package manager functions
if [[ -e /etc/debian_version ]]
then
    alias search='apt-cache search --names-only'
    alias add='apt-get install'
    alias show='apt-cache show'
    alias purge='apt-get autoremove'
    alias dist-upgrade='apt-get dist-upgrade'
    alias dist-sync='apt-get update'
    alias list='dpkg -L'
## Fedora-based distros package manager functions
elif [[ -e /etc/fedora-release ]]
then
    alias search='yum search'
    alias add='yum install'
    alias show='yum info'
    alias purge='yum erase'
    alias dist-upgrade='yum upgrade'
#    alias dist-sync='apt-get update'   # this is handled automatically by yum
    alias list='repoquery --list'
fi


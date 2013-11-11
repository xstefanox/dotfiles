#!/bin/bash

##################
## LOCALIZATION ##
##################

[[ -z "$LC_ALL" && -n "$LANG" ]] && export LC_ALL="$LANG"
[[ -z "$LANG" && -n "$LC_ALL" ]] && export LANG="$LC_ALL"

########
# BASH #
########

# Fix cd typos
shopt -s cdspell

# Treat undefined variables as errors
#set -o nounset

# Don't attempt to search the PATH for possible completions when completion is attempted on an empty line
shopt -s no_empty_cmd_completion

############
## COLORS ##
############

## import the colors file, if exists
[[ -e "${HOME}/.bash_colors" ]] && source "${HOME}/.bash_colors"

############
## PROMPT ##
############

## import the prompt file, if exists
[[ -e "${HOME}/.bash_prompt" ]] && source "${HOME}/.bash_prompt"

##############
## HOME BIN ##
##############

## define the path to the user binaries
if [[ $(uname -s) == Darwin ]]
then
    home_bin="$HOME/Library/bin"
else
    home_bin="$HOME/.local/bin"
fi

## ensure home_bin exists
[[ ! -d "$home_bin" ]] && mkdir -p "$home_bin"

## add home_bin to the PATH
export PATH="$home_bin:$PATH"

## cleanup
unset home_bin

####################
## BASHRC MODULES ##
####################

## define the path to the bashrc modules directory
bashrc_modules_dir="$HOME/.bashrc.d"

## ensure bashrc_modules_dir exists
[[ ! -d "$bashrc_modules_dir" ]] && mkdir -p "$bashrc_modules_dir"

## execute each bashrc script
which run-parts &> /dev/null && run-parts --regex '\.sh$' "$bashrc_modules_dir"

## cleanup
unset bashrc_modules_dir

##############
## HOMEBREW ##
##############

# Add the Homebrew PATH
if [[ $(uname -s) == Darwin && -d "$HOME/Library/Homebrew" ]]
then
    export PATH=$HOME/Library/Homebrew/bin:$PATH
    export PATH=$HOME/Library/Homebrew/sbin:$PATH
fi

#####################
## BASH COMPLETION ##
#####################

if [[ $(uname -s) == Darwin ]]
then
    if which brew &> /dev/null
    then
        brew_prefix=$(brew --prefix)
        source "${brew_prefix}/Library/Contributions/brew_bash_completion.sh"
        unset brew_prefix
    fi
else
    [[ -z "$BASH_COMPLETION" && -f /etc/bash_completion ]] && export BASH_COMPLETION=/etc/bash_completion
    [[ -z "$BASH_COMPLETION_DIR" && -f /etc/bash_completion.d ]] && export BASH_COMPLETION_DIR=/etc/bash_completion.d
    [[ -z "$BASH_COMPLETION_COMPAT_DIR" && -f /etc/bash_completion.d ]] && export BASH_COMPLETION_COMPAT_DIR=/etc/bash_completion.d
fi

# TAB-completion for sudo
complete -cf sudo

# TAB-completion for ssh hostnames that reads the user configuration file
function _ssh()
{
    local cur prev opts config
    
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    config="${HOME}/.ssh/config"
    opts="$([[ -f "${config}" ]] && \grep "^Host" "${config}" | cut -d' ' -f2)"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _ssh ssh

############
## EDITOR ##
############

if [[ $(uname -s) == Darwin ]]
then
    if which mate &> /dev/null
    then
        export EDITOR="mate -w"
    else
        export EDITOR=nano
    fi
elif [[ -n "$DISPLAY" ]]
then
    if which geany &> /dev/null
    then
        export EDITOR=geany
    elif which gedit &> /dev/null
    then
        export EDITOR=gedit
    fi
else
    export EDITOR=nano
fi

###########
## PAGER ##
###########

if which most &> /dev/null
then
    export PAGER=most
elif which less &> /dev/null
then
    export PAGER=less
fi

############
## PYTHON ##
############

export PYTHONSTARTUP=$HOME/.pythonrc
export PYTHONHISTORY=$HOME/.python_history
    
# Mac OSX 10.7 Lion supports only Python 2.7
if [[ $(uname -s) == Darwin ]]
then
    export PYTHONPATH27=$HOME/Library/Python/2.7/site-packages
    export PYTHONPATH33=$HOME/Library/Python/3.3/site-packages
    export PYTHONBINPATH27=$PYTHONPATH27/bin
    export PYTHONBINPATH33=$PYTHONPATH33/bin
    export PATH=$PYTHONBINPATH33:$PYTHONBINPATH27:$PATH
    export PYTHONPATH=$PYTHONPATH33:$PYTHONPATH27:$PYTHONPATH

    # don't use the bloated easy_install
    alias easy_install='echo "!!! Deprecated"; false'
    alias easy_install-2.5='echo "!!! Deprecated"; false'
    alias easy_install-2.6='echo "!!! Deprecated"; false'
    alias easy_install-2.7='echo "!!! Deprecated"; false'
    alias easy_install3='echo "!!! Deprecated"; false'
    alias easy_install-3.3='echo "!!! Deprecated"; false'

    # make pip use the default paths and install every egg into the user home
    
    which pip &> /dev/null && function pip()
    {
        pip=$(which pip)

        if [[ $1 == install ]]
        then
            $pip $@ --install-option="--install-purelib=$PYTHONPATH27" --install-option="--install-platlib=$PYTHONPATH27" --install-option="--prefix=$PYTHONPATH27"
        else
            $pip $@
        fi
    } && export -f pip
    
    which pip3 &> /dev/null && function pip3()
    {
        pip3=$(which pip3)

        if [[ $1 == install ]]
        then
            $pip3 $@ --install-option="--install-purelib=$PYTHONPATH33" --install-option="--install-platlib=$PYTHONPATH33" --install-option="--prefix=$PYTHONPATH33"
        else
            $pip3 $@
        fi
    } && export -f pip3
fi

#########
## PHP ##
#########

# Pear
[[ $UID != 0 ]] && alias pear='sudo pear'
[[ $UID != 0 ]] && alias pecl='sudo pecl'

# Composer: define a wrapper that automatically invokes the project composer if it exists,
# falls back on the system compoer if it exists or asks for installation in the current directory
# if no composer is found on your system
function composer()
{
    local composer args cmd_args item
    
    # use the project composer if exists
    if [[ -f composer.phar ]]
    then
        composer="./composer.phar"
    elif [[ -f composer ]]
    then
        composer="./composer"
    # use the system composer if exists
    elif which composer.phar &> /dev/null
    then
        composer="$(which composer.phar)"
    elif which composer &> /dev/null
    then
        composer="$(which composer)"
    fi
    
    # run composer if found
    if [[ -n "${composer}" ]]
    then
        # check if installation of custom repository has been required
        
        cmd_args="$@"
        
        declare -a args
        
        # strip --* arguments from $@
        for item in $@
        do
            [[ "${item}" != --* ]] && args+=( "${item}" )
        done
        
        # if the selected command is create-project and the selected project is our custom project
        if [[ "${args[0]}" == 'create-project' ]] && [[ "${args[1]}" == 'symfony/framework-contactlab-edition' ]]
        then
            cmd_args+=" --repository-url='http://svn.tomatowin.local/projects'"
        fi
        
        eval php -d memory_limit=750M $composer $cmd_args
    else
        # ask for installation
        echo "Composer not installed"
        echo -n "Do you want to install Composer in the local directory? [yN] "
        while read install
        do
            if [[ "${install}" == N ]] || [[ -z "${install}" ]]
            then
                break
            elif [[ "${install}" == y ]]
            then
                curl -sS https://getcomposer.org/installer | php  -- --install-dir=.
                break
            else
                echo "Not recognized: ${install}"
                echo -n "Do you want to install Composer in the local directory? [yN] "
            fi
        done
    fi
} && export -f composer

# import PhpBrew invironment if found
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

#########
## GIT ##
#########

if which git &> /dev/null
then
    git config --global user.name "Stefano Varesi"
    git config --global user.email "stefano.varesi@gmail.com"
    # disabled: this creates a daemon and a warning is always raised when closing the window in Mac OSX
    #git config --global credential.helper cache
    git config --global color.ui true
    git config --global color.status.added "green $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.changed "yellow $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.untracked "red $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.unmerged "red $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.meta "yellow $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.old "red $([[ $(uname -s) == Linux ]] && echo black)"
    git config --global core.excludesfile "~/.gitignore.global"
    git config --global push.default $(git --version | grep --silent " 1.8" && echo simple || echo matching)
fi 

#########
## WII ##
#########

[[ $(uname -s) == Darwin ]] && export PATH=/Volumes/WII/bin:$PATH || export PATH=/media/WII/bin:$PATH

#########
## RVM ##
#########

if [[ -d "${HOME}/.rvm" ]]
then
    PATH=$HOME/.rvm/bin:$PATH
    [[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"
fi

############
## NODEJS ##
############

if [[ $(uname -s) == Darwin ]] && which brew &> /dev/null && which npm &> /dev/null
then
    # get the Homebrew installation path
    homebrew_path=$(brew --prefix)
    
    # add the NodeJS binaries installed by Homebrew to the path
    PATH=${homebrew_path}/share/npm/bin:$PATH
    
    # add the NodeJS modules installation paths
    export NODE_PATH=${homebrew_path}/share/npm/lib/node_modules:${homebrew_path}/lib/node_modules/npm/node_modules:$NODE_PATH
    
    unset homebrew_path
fi

#########
## MAN ##
#########

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
        $(which man) $([[ -z "$PAGER" ]] && echo --pager=$(which most &> /dev/null && echo most || echo less)) $page
        
    fi
}

########################
## PACKAGE MANAGEMENT ##
########################

## dpkg-based distros package manager functions
if which dpkg &> /dev/null
then
    [[ $UID == 0 ]] && alias add='apt-get install' || alias add='sudo apt-get install'
    [[ $UID == 0 ]] && alias purge='apt-get autoremove' || alias purge='sudo apt-get autoremove'
    [[ $UID == 0 ]] && alias dist-upgrade='apt-get dist-upgrade' || alias dist-upgrade='sudo apt-get dist-upgrade'
    [[ $UID == 0 ]] && alias dist-sync='apt-get update' || alias dist-sync='sudo apt-get update'
    alias search='apt-cache search --names-only'
    alias show='apt-cache show'
    alias list='dpkg -L'
## rpm-based distros using yum package manager functions
elif which yum &> /dev/null
then
    [[ $UID == 0 ]] && alias add='yum install' || alias add='sudo yum install'
    [[ $UID == 0 ]] && alias purge='yum erase' || alias purge='sudo yum erase'
    [[ $UID == 0 ]] && alias dist-upgrade='yum upgrade' || alias dist-upgrade='sudo yum upgrade'
    alias dist-sync='yum check-update'
    alias search='yum search'
    alias show='yum info'
    alias list='repoquery --list'
fi

########################
## SERVICE MANAGEMENT ##
########################

## Linux
if [[ $(uname -s) == Linux ]] && which service &> /dev/null
then
    [[ $UID != 0 ]] && alias service='sudo service'
fi

####################
## OS PREFERENCES ##
####################

## Mac OSX
if [[ $(uname -s) == Darwin ]]
then

    ## do not write useless trash to samba shares
    defaults write com.apple.desktopservices DSDontWriteNetworkStores true

    ## disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    ## don't run anything on X11/XQuartz opening
    defaults write org.x.X11 app_to_run /usr/bin/true
    defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
    
    ## disable the Dashboard
    defaults write com.apple.dashboard mcx-disabled -bool true
    
    ## disable previews in Mail attachments
    defaults write com.apple.mail DisableInlineAttachmentViewing -bool yes

## Linux
else

    ## Preferences requiring an active X11 session
    if [[ -n "$DISPLAY" ]]
    then
        if which gsettings &> /dev/null
        then
            if gsettings list-schemas | grep --silent org.gnome.gedit.preferences.editor
            then
                gsettings set org.gnome.gedit.preferences.editor tabs-size 4
                gsettings set org.gnome.gedit.preferences.editor insert-spaces true
                gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
                gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
                gsettings set org.gnome.gedit.preferences.editor auto-indent true
            fi
        fi
        
        ## if using Ubuntu
        if which lsb_release &> /dev/null && [[ "$(lsb_release --id | sed 's/.*:[[:space:]]*\(.*\)/\1/')" == Ubuntu ]]
        then
            ## disable the Unity scrollbar
            export LIBOVERLAY_SCROLLBAR=0
        fi
    fi

fi

# Firefox preferences
#if [[ -e "${HOME}/.mozilla/firefox/" ]]
#then
#    for item in $(find ${HOME}/.mozilla/firefox/ -maxdepth 1 -type d -name '*.default')
#    do
#        sed -i '/browser.display.focus_ring_width/ s:1:0:' "${item}/prefs.js"
#        sed -i '/browser.display.focus_ring_on_anything/ s:false:true:' "${item}/prefs.js"
#        
#        if grep --quiet extensions.blocklist.enabled "${item}/prefs.js"
#        then
#            sed -i '/extensions.blocklist.enabled/ s:false:true:' "${item}/prefs.js"
#        else
#            sed -i '$ a user_pref("extensions.blocklist.enabled", true);' "${item}/prefs.js"
#        fi
#    done
#fi

##########
## MISC ##
##########

## Maximum allowed file size on a FAT32 filesystem
export FAT32_MAX_FILE_SIZE="$((2**32 - 1))"

## Size of a Nintendo WII ISO image
export WII_ISO_SIZE="4699979776"

## Enable colors on directory listing
if [[ $(uname -s) == Darwin || $(uname -s) == FreeBSD ]]
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
alias grep='grep --color -n'

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

## List all the open TCP or UDP ports on the machine
alias open-ports='nc -vz localhost 1-65535 2>&1 | $(which grep) -i succeeded'

## A shortcut to open a file or a directory
if [[ $(uname -s) == Darwin ]]
then
    alias o='open'
else
    # on other Unices, check for an active X11 session
    [[ $(uname -s) == Linux ]] && [[ -n "$DISPLAY" ]] && alias o='xdg-open' || alias o='$EDITOR'
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
[[ $(uname -s) == Darwin ]] && which abcde &> /dev/null && function rip()
{
    dev="$(mount | \grep cddafs | cut -d' ' -f1)"
    
    if [[ -n "$dev" ]]
    then
        # unmount the disc
        hdiutil unmount "$dev" -quiet && abcde -d "$dev" -N -a read,encode,move,clean
    fi
}

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
if [[ $(uname -s) == Darwin ]]
then
    alias edit='open -a TextMate'
fi

## Desktop notification
if [[ $(uname -s) == Darwin ]]
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

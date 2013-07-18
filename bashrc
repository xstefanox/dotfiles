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

# Reset
NO_COLOR='\033[0m'        # Text Reset

# Regular Colors
BLACK='\033[0;30m'        # BLACK
RED='\033[0;31m'          # RED
GREEN='\033[0;32m'        # GREEN
YELLOW='\033[0;33m'       # YELLOW
BLUE='\033[0;34m'         # BLUE
PURPLE='\033[0;35m'       # PURPLE
CYAN='\033[0;36m'         # CYAN
WHITE='\033[0;37m'        # WHITE

# Bold
BBLACK='\033[1;30m'       # BLACK
BRED='\033[1;31m'         # RED
BGREEN='\033[1;32m'       # GREEN
BYELLOW='\033[1;33m'      # YELLOW
BBLUE='\033[1;34m'        # BLUE
BPURPLE='\033[1;35m'      # PURPLE
BCYAN='\033[1;36m'        # CYAN
BWHITE='\033[1;37m'       # WHITE

# Underline
UBLACK='\033[4;30m'       # BLACK
URED='\033[4;31m'         # RED
UGREEN='\033[4;32m'       # GREEN
UYELLOW='\033[4;33m'      # YELLOW
UBLUE='\033[4;34m'        # BLUE
UPURPLE='\033[4;35m'      # PURPLE
UCYAN='\033[4;36m'        # CYAN
UWHITE='\033[4;37m'       # WHITE

# Background
ON_BLACK='\033[40m'       # BLACK
ON_RED='\033[41m'         # RED
ON_GREEN='\033[42m'       # GREEN
ON_YELLOW='\033[43m'      # YELLOW
ON_BLUE='\033[44m'        # BLUE
ON_PURPLE='\033[45m'      # PURPLE
ON_CYAN='\033[46m'        # CYAN
ON_WHITE='\033[47m'       # WHITE

# High Intensty
IBLACK='\033[0;90m'       # BLACK
IRED='\033[0;91m'         # RED
IGREEN='\033[0;92m'       # GREEN
IYELLOW='\033[0;93m'      # YELLOW
IBLUE='\033[0;94m'        # BLUE
IPURPLE='\033[0;95m'      # PURPLE
ICYAN='\033[0;96m'        # CYAN
IWHITE='\033[0;97m'       # WHITE

# Bold High Intensty
BIBLACK='\033[1;90m'      # BLACK
BIRED='\033[1;91m'        # RED
BIGREEN='\033[1;92m'      # GREEN
BIYELLOW='\033[1;93m'     # YELLOW
BIBLUE='\033[1;94m'       # BLUE
BIPURPLE='\033[1;95m'     # PURPLE
BICYAN='\033[1;96m'       # CYAN
BIWHITE='\033[1;97m'      # WHITE

# High Intensty backgrounds
ON_IBLACK='\033[0;100m'   # BLACK
ON_IRED='\033[0;101m'     # RED
ON_IGREEN='\033[0;102m'   # GREEN
ON_IYELLOW='\033[0;103m'  # YELLOW
ON_IBLUE='\033[0;104m'    # BLUE
ON_IPURPLE='\033[10;95m'  # PURPLE
ON_ICYAN='\033[0;106m'    # CYAN
ON_IWHITE='\033[0;107m'   # WHITE

############
## PROMPT ##
############

# save the return value of the last executed process
PROMPT_COMMAND='PS1_return_value=$?;'

# translate the saved return value in a colored string containing the error description
PS1_return_value='$(
    if [[ "${PS1_return_value}" == 0 ]];
    then
        echo -ne "${NO_COLOR}($([[ $(uname -s) == Darwin ]] && echo "${GREEN}" || echo "${BGREEN}")${PS1_return_value}${NO_COLOR})";
    else
        echo -ne "${NO_COLOR}($([[ $(uname -s) == Darwin ]] && echo "${RED}" || echo "${BRED}")${PS1_return_value}:$(python -c "import os; print(os.strerror(${PS1_return_value}))")${NO_COLOR})";
    fi
)'

# generate a colored string describing the status of the Git working copy in the current directory
PS1_git_status='$(
    if which git &> /dev/null && git status &> /dev/null;
    then
        echo -ne "${NO_COLOR}{";
        
        if [[ -z "$(git status -s)" ]];
        then
            [[ $(uname -s) == Darwin ]] && echo -ne "${GREEN}" || echo -ne "${BGREEN}";
        else
            [[ $(uname -s) == Darwin ]] && echo -ne "${RED}" || echo -ne "${BRED}";
        fi;
        
        echo -n "git:";
        
        branch="$(git branch --no-color | sed -n "/^*/ s:[^ ]* :: p")";
        echo -n "${branch}";
        
        echo -ne "${NO_COLOR}}";
    fi
)'

# generate a colored string describing the status of the Subversion working copy in the current directory
PS1_svn_status='$(
    if which svn &> /dev/null && svn info &> /dev/null;
    then
        url=$(svn info | sed -n "/^URL/ s/URL:[[:space:]]*// p");
        
        if [[ "${url/:*/}" != "file" ]];
        then
            host="${url/*:\/\//}";
            host="${host/\/*/}";
            
            echo -ne "${NO_COLOR}{";
            
            if ping -c1 -W1 "${host}" &> /dev/null;
            then

                status="$(svn status -u | \grep ^[^[:space:]])"

                if [[ -z "$(echo "${status}" | sed "$ d")" ]];
                then
                    [[ $(uname -s) == Darwin ]] && echo -ne "${GREEN}" || echo -ne "${BGREEN}";
                else
                    [[ $(uname -s) == Darwin ]] && echo -ne "${RED}" || echo -ne "${BRED}";
                fi
                
                rev="$(echo "${status}" | sed -n "$ s/[[:alnum:][:space:]]\+:[[:space:]]*\([[:digit:]]*\)/svn:rev\1/ p")";
                echo -n "${rev}";
            else
                echo -ne "$([[ $(uname -s) == Darwin ]] && echo -ne "${YELLOW}" || echo -ne "${BYELLOW}")svn:unknown";
            fi;
            
            echo -ne "${NO_COLOR}}";
        fi
    fi
)'

# generate the final source code management status description string
PS1_scm_status="${PS1_git_status}${PS1_svn_status}"

# color the username depending on user being root or not
user_color="$(
    if [[ $UID == 0 ]]
    then
        [[ $(uname -s) == Darwin ]] && echo "${RED}" || echo "${BRED}"
    else
        [[ $(uname -s) == Darwin ]] && echo "${GREEN}" || echo "${BGREEN}"
    fi
)"

## PS1: Default prompt
PS1="[${user_color}\u$([[ $(uname -s) == Darwin ]] && echo "${YELLOW}" || echo "${BYELLOW}")@\h${NO_COLOR}:$([[ $(uname -s) == Darwin ]] && echo "${BLUE}" || echo "${BBLUE}")\w${NO_COLOR}]${PS1_return_value}${PS1_scm_status}\n\$ "

# clean the environment
unset PS1_return_value PS1_git_status PS1_svn_status PS1_scm_status user_color

## Use Bash defaults for continuation prompt (PS2) and select prompt (PS3)

## PS4: Debug prompt
PS4='$0, Line $LINENO: '

##############
## HOME BIN ##
##############

## Path to the user binaries
if [[ $(uname -s) == Darwin ]]
then
    export HOME_BIN="$HOME/Library/bin"
else
    export HOME_BIN="$HOME/.local/bin"
fi

## Ensure HOME_BIN exists
[[ ! -d "$HOME_BIN" ]] && mkdir -p "$HOME_BIN"

## Add HOME_BIN to the PATH
export PATH="$HOME_BIN:$PATH"

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
        source "${brew_prefix}/etc/bash_completion"
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
    export EDITOR=gedit
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
    export PYTHONBINPATH27=$PYTHONPATH27/bin
    export PATH=$PYTHONBINPATH27:$PATH
    export PYTHONPATH=$PYTHONPATH27:$PYTHONPATH

    # don't use the bloated easy_install
    alias easy_install='echo "!!! Deprecated"; false'
    alias easy_install-2.5='echo "!!! Deprecated"; false'
    alias easy_install-2.6='echo "!!! Deprecated"; false'
    alias easy_install-2.7='echo "!!! Deprecated"; false'

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
fi

#########
## PHP ##
#########

alias pear='[[ $UID == 0 ]] && pear || sudo pear'
alias pecl='[[ $UID == 0 ]] && pecl || sudo pecl'

#########
## GIT ##
#########

if which git &> /dev/null
then
    git config --global user.name "Stefano Varesi"
    # disabled: this creates a daemon and a warning is always raised when closing the window in Mac OSX
    #git config --global credential.helper cache
    git config --global color.ui true
    git config --global color.status.added "green $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.changed "yellow $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.untracked "red $([[ $(uname -s) == Linux ]] && echo bold)"
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
    alias search='apt-cache search --names-only'
    alias add='[[ $UID == 0 ]] && apt-get install || sudo apt-get install'
    alias show='apt-cache show'
    alias purge='[[ $UID == 0 ]] && apt-get autoremove || sudo apt-get autoremove'
    alias dist-upgrade='[[ $UID == 0 ]] && apt-get dist-upgrade || sudo apt-get dist-upgrade'
    alias dist-sync='[[ $UID == 0 ]] && apt-get update || sudo apt-get update'
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

########################
## SERVICE MANAGEMENT ##
########################

## Linux
if [[ $(uname -s) == Linux ]]
then
    
    which service &> /dev/null && alias service='[[ $UID == 0 ]] && service || sudo service'
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

##########
## MISC ##
##########

## Maximum allowed file size on a FAT32 filesystem
export FAT32_MAX_FILE_SIZE="$((2**32 - 1))"

## Size of a Nintendo WII ISO image
export WII_ISO_SIZE="4699979776"

## Enable colors on directory listing
if [[ $(uname -s) == Darwin ]]
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

## List all the open TCP or UDP ports on the machine
alias open-ports='nc -vz localhost 1-65535 2>&1 | $(which grep) -i succeeded'

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

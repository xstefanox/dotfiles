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

####################
## BASHRC MODULES ##
####################

## define the path to the bashrc modules directory
bashrc_modules_dir="$HOME/.bashrc.d"

## ensure bashrc_modules_dir exists
[[ ! -d "$bashrc_modules_dir" ]] && mkdir -p "$bashrc_modules_dir"

## execute each bashrc script
for item in $(find $HOME/.bashrc.d -type f -regex '.*\.sh$' | sort)
do
    source "${item}"
done

## cleanup
unset bashrc_modules_dir item

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
    if which subl &> /dev/null
    then
        export EDITOR=subl
    elif which geany &> /dev/null
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
#[[ $UID != 0 ]] && alias pear='sudo pear'
#[[ $UID != 0 ]] && alias pecl='sudo pecl'

# Composer: add user packages bin directory to the PATH
PATH=$HOME/.composer/vendor/bin:$PATH

# phpbrew
[[ -e ~/.phpbrew ]] && source ~/.phpbrew/bashrc

# XDebug
alias xdebug-on='export XDEBUG_CONFIG="remote_enable=1"'
alias xdebug-off='export XDEBUG_CONFIG="remote_enable=0"'

#export PHP_IDE_CONFIG="serverName={SERVER NAME IN PHP STORM}"
#export XDEBUG_CONFIG="remote_host={YOUR_IP} idekey=PHPSTORM"

# default is disabled
export XDEBUG_CONFIG="remote_enable=0"

# modules
if [[ $UID != 0 ]]
then
    alias php5enmod='sudo php5enmod'
    alias php5dismod='sudo php5dismod'
fi

##!/bin/bash
#
## Composer: define a wrapper that automatically invokes the project composer if it exists,
## or asks for installation in the project if no composer is found in the current directory
#
#declare composer args cmd_args item
#
## use the project composer if exists
#if [[ -f composer.phar ]]
#then
#    composer="./composer.phar"
#elif [[ -f composer ]]
#then
#    composer="./composer"
#fi
#
## run composer if found
#if [[ -n "${composer}" ]]
#then
#    php -d memory_limit=750M $composer $@
#else
#    # ask for installation
#    echo -e  "\033[0;33mComposer not found!"
#    echo -ne "\033[0;32mDo you want to install Composer in the local directory? \033[0;33m[yN]\033[0m: "
#    while read install
#    do
#        if [[ "${install}" == N ]] || [[ -z "${install}" ]]
#        then
#            break
#        elif [[ "${install}" == y ]]
#        then
#            curl -sS https://getcomposer.org/installer | php  -- --install-dir=.
#            break
#        else
#            echo "Not recognized: ${install}"
#            echo -n "Do you want to install Composer in the local directory? [yN] "
#        fi
#    done
#fi

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
    git config --global color.status.added     "green $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.changed   "yellow $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.untracked "red $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.status.unmerged  "red $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.meta "yellow $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.frag "magenta $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.old  "red $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global color.diff.new  "blue $([[ $(uname -s) == Linux ]] && echo bold)"
    git config --global core.excludesfile "~/.gitignore.global"
    git config --global push.default $(git --version | grep --silent " 1.8" && echo simple || echo matching)

    # @see https://gist.github.com/unphased/5303697
    git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

    # install diff-highlight from git distribution
    cp /usr/share/doc/git/contrib/diff-highlight/diff-highlight "${home_bin}/"
    chmod +x "${home_bin}/diff-highlight"

    if which diff-highlight &> /dev/null
    then
        git config --global pager.log  'diff-highlight | less'
        git config --global pager.show 'diff-highlight | less'
        git config --global pager.diff 'diff-highlight | less'
    fi
fi 

#########
## SVN ##
#########

if which svn &> /dev/null
then
    alias svn-ignore='EDITOR="nano" svn propedit svn:ignore'

    #git add -A && git commit -m 'Versione 1.3' && git svn dcommit && git svn tag 1.3

    function svn-release()
    {
        local tag=$1
        local current_tag
        local trunk_list
        local current_tag_list
        local files_diff
        
        # ensure tag is not empty
        [[ -z "${tag}" ]] && echo "Usage: svn-release <tag>" && return 1

        # check if we are in a svn working copy with a standard layout
        dirs="$(find . -mindepth 1 -maxdepth 1 -not -name .svn)"
        [[ -z "$(echo "$dirs" | grep \./trunk)" || -z "$(echo "$dirs" | grep \./branches)" || -z "$(echo "$dirs" | grep \./tags)" ]] && echo "The current directory is not a Subversion working copy with a standard layout" && return 1
        [[ "$(echo "${dirs}" | wc -l)" -gt 3 ]] && echo "Unknown files or directories in the current directory, unable to proceed" && return 1
        unset dirs
        
        # check if trunk has local modifications
        [[ -n "$(svn status trunk)" ]] && echo "Trunk has local modifications, commit or revert them before releasing" && return 1

        # check if the given tag is a valid semver tag
        [[ -z "$(echo "${tag}" | grep "^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+$")" ]] && echo "Invalid semver tag: ${tag}" && return 1

        # ensure ^/tags/ is updated
        svn update tags

        # read the last released version
        current_tag="$(find tags -mindepth 1 -maxdepth 1 | sort | sed -n '$ s:tags/:: p')"
        
        # if this is a first release
        if [[ -z "${current_tag}" ]]
        then
        
            svn copy trunk "tags/${tag}" && svn commit -m "Version ${tag}"
            
        else
        
            # check if the given tag is greater than the last existing tag
            [[ "${tag}" < "${current_tag}" ]] && echo "You must provide a tag greater than ${current_tag}" && return 1
            
            # check if the given tag already exists
            [[ "${tag}" == "${current_tag}" ]] && echo "Tag ${current_tag} already exists" && return 1
            
            # check if there are actually differences between the current version and trunk
            
            trunk_list="$(mktemp -t svn-release.XXXXXXXXXX)"
            current_tag_list="$(mktemp -t svn-release.XXXXXXXXXX)"
            
            find trunk -mindepth 1 | sed 's:^trunk/::' > "${trunk_list}"
            find "tags/${current_tag}" -mindepth 1 | sed 's:tags/'${current_tag}'/::' >     "${current_tag_list}"
            files_diff="$(diff "${trunk_list}" "${current_tag_list}")"
            rm "${trunk_list}" "${current_tag_list}"

            if [[ -z "$(diff -r trunk "tags/${current_tag}")" ]] && [[ -z "${files_diff}" ]]
            then
                echo "No differences between trunk and the current release, refusing to release a useless version" && return 1
            fi
            
            svn copy "tags/${current_tag}" "tags/${tag}" && svn rm tags/${tag}/* && cp -r trunk/* "tags/${tag}/" && svn add tags/${tag}/* && svn commit -m "Version ${tag}"
        fi
    }
fi

#########
## WII ##
#########

[[ $(uname -s) == Darwin ]] && export PATH=/Volumes/WII/bin:$PATH || export PATH=/media/WII/bin:$PATH

##########
## RUBY ##
##########

# install gems in user home
if which gem &> /dev/null
then
    export GEM_HOME="${HOME}/.gem"
    export PATH="${HOME}/.gem/bin:${PATH}"
fi

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

if which npm &> /dev/null
then
    if [[ $(uname -s) == Darwin ]] && which brew &> /dev/null
    then
        # get the Homebrew installation path
        homebrew_path=$(brew --prefix)
        
        # add the NodeJS binaries installed by Homebrew to the path
        PATH=${homebrew_path}/share/npm/bin:$PATH
        
        # add the NodeJS modules installation paths
        export NODE_PATH=${homebrew_path}/share/npm/lib/node_modules:${homebrew_path}/lib/node_modules/npm/node_modules:$NODE_PATH
        
        unset homebrew_path
        
    elif [[ $(uname -s) == Linux ]]
    then
        # set the correct paths to install global npm modules in user home
        npm config set prefix ~/.npm
        npm config set cache ~/.npm/cache
        
        # add the npm binary path to the PATH
        PATH=$HOME/.npm/bin:$PATH
    fi
fi

################
## CAPISTRANO ##
################

if which cap &> /dev/null
then
    function _cap()
    {
        local cur prev opts
        
        # avoid using : to split words
        _get_comp_words_by_ref -n : cur prev
        
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(cap --tasks | sed -n '/^cap/ s/^cap \([[:alnum:]:-]\+\)[[:space:]]*# .*$/\1/ p')"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        
        __ltrim_colon_completions "$cur"
    }
    
    complete -F _cap cap
fi

#############
## SYMFONY ##
#############

if which php &> /dev/null
then
    function _symfony_console()
    {
        local cur prev opts
        
        # avoid using : to split words
        _get_comp_words_by_ref -n : cur prev
        
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(app/console list | sed -n '/^Available commands:/,$ s/^  \([[:alnum:]:-]\+\)[[:space:]]*.*$/\1/ p')"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        
        __ltrim_colon_completions "$cur"
    }
    
    complete -F _symfony_console console
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
            xdg-open http://manpages.ubuntu.com/manpages/$(which lsb_release &> /dev/null && lsb_release --codename --short)/en/${category}/${page} 2> /dev/null
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
    
    function apt-list-from-repository()
    {
        eval "aptitude search '~S ~i (~O"$1")'"
    }
    
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
if [[ $(uname -s) == Linux ]]
then
    # define a wrapper arount service and start/restart/stop commands
    function _service_manager()
    {
        # on Ubuntu and derived distros
        if which _upstart_jobs &> /dev/null
        then
            if [[ $UID != 0 ]]
            then
                _upstart_jobs | grep --silent $2 && sudo $1 $2 || sudo service $2 $1
            else
                _upstart_jobs | grep --silent $2 && $1 $2 || service $2 $1
            fi
        elif which invoke-rc.d &> /dev/null
        then
            if [[ $UID != 0 ]]
            then
                find /etc/init.d/ -not -name '.*' -exec basename {} \; | grep $2 &> /dev/null && sudo service $2 $1
            else
                find /etc/init.d/ -not -name '.*' -exec basename {} \; | grep $2 &> /dev/null && service $2 $1
            fi
        fi
    }
    
    alias start='_service_manager start'
    alias stop='_service_manager stop'
    alias restart='_service_manager restart'
    alias reload='_service_manager reload'
fi

############
## APACHE ##
############

if which apache2ctl &> /dev/null
then
    [[ $UID != 0 ]] && alias a2enmod='sudo a2enmod'
    [[ $UID != 0 ]] && alias a2ensite='sudo a2ensite'
    [[ $UID != 0 ]] && alias a2dismod='sudo a2dismod'
    [[ $UID != 0 ]] && alias a2dissite='sudo a2dissite'
    [[ $UID == 0 ]] && alias a2vhosts='apache2ctl -t -D DUMP_VHOSTS' || alias a2vhosts='sudo apache2ctl -t -D DUMP_VHOSTS'
    [[ $UID == 0 ]] && alias a2modules='apache2ctl -t -D DUMP_MODULES' || alias a2modules='sudo apache2ctl -t -D DUMP_MODULES'
    
    # an utility function to generate virtual hosts configuration files
    function a2genvhost()
    {
        local server_name=$1
        local document_root=$2
        local force=$3
        local vhosts_path="/etc/apache2/sites-available"
        local file_ext
        
        [[ -z "${server_name}" || -z "${document_root}" ]] && echo "Usage: ${FUNCNAME} <server_name> <document_root> [--force]" && return 1

        if [[ $(apache2 -v | sed -n '/Server version/ s:.*/[[:digit:]]\+\.\([[:digit:]]\+\).*:\1: p') -ge 4 ]]
        then
            file_ext=".conf"
        fi
        
        [[ -e "${vhosts_path}/${server_name}${file_ext}" && "${force}" != "--force" ]] && echo "VirtualHost ${server_name} already exists" && return 1
        
        groupname="$(groups | awk '{ print $1 }')"
        
        vhost_content="$(cat << __EOT__
<VirtualHost *:80>

    DocumentRoot ${document_root}
    ServerName ${server_name}.localhost

    <Directory ${document_root}>
        Options Indexes FollowSymlinks MultiViews
        AllowOverride all
        AssignUserID ${USER} ${groupname}

        ## Apache 2.4
        <IfModule mod_authz_core.c>
            Require all granted
        </IfModule>

        ## Apache 2.2
        <IfModule !mod_authz_core.c>
            Order allow,deny
            Allow from all
        </IfModule>

    </Directory>

</VirtualHost>

__EOT__
)"
        
        if [[ $UID != 0 ]]
        then
            echo "${vhost_content}" | sudo tee "${vhosts_path}/${server_name}${file_ext}" &> /dev/null
        else
            echo "${vhost_content}" > "${vhosts_path}/${server_name}${file_ext}"
        fi
        
        echo "VirtualHost configured, reload Apache to enable"
    }
fi

###########
## SKYPE ##
###########

# remember to install the following packages to fix the theme on 64bit machines
# gtk2-engines-murrine:i386 gtk2-engines-pixbuf:i386

#########
## SSH ##
#########

# wrap the ssh command to automatically restore the window title on exit
which ssh &> /dev/null && function ssh()
{
    local ssh="'$(which ssh)'"
    local item
    local retval

    # quote each argument
    for item in $@
    do
        ssh+=" '${item}'"
    done

    # execute the command
    eval "${ssh}"

    # save the return value
    retval=$?

    # restore the window title
    echo -ne "\033]0;Terminal\007"

    return $retval
}

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
        ## on Ubuntu
        if which lsb_release &> /dev/null && [[ "$(lsb_release --id --short)" == Ubuntu ]]
        then
            ## disable the Unity scrollbar
            if [[ "$(lsb_release --release --short)" > '12.04' ]]
            then
                # on current Ubuntu release
                gsettings set com.canonical.desktop.interface scrollbar-mode normal
            else
                # on 12.04 or older releases
                gsettings set org.gnome.desktop.interface ubuntu-overlay-scrollbars false
            fi
            
            #export LIBOVERLAY_SCROLLBAR=0
            #echo 'export LIBOVERLAY_SCROLLBAR=0' >> ~/.xprofile
        fi
        
        # desktop preferences: MATE
        if gsettings list-schemas | grep org.mate.caja &> /dev/null
        then
            gsettings set org.mate.background       show-desktop-icons    true
            gsettings set org.mate.caja.desktop     computer-icon-visible false
            gsettings set org.mate.caja.desktop     home-icon-visible     false
            gsettings set org.mate.caja.desktop     network-icon-visible  false
            gsettings set org.mate.caja.desktop     trash-icon-visible    false
            gsettings set org.mate.caja.desktop     volumes-visible       false
            gsettings set org.mate.caja.preferences default-folder-viewer list-view
            gsettings set org.mate.caja.list-view   default-zoom-level    smallest
            # @fixme
            #gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
            #gsettings set org.gnome.desktop.interface    font-name             'Ubuntu 10'
            #gsettings set org.gnome.desktop.interface   document-font-name    'Sans 11'
            #gsettings set org.gnome.nautilus.desktop    font                  ''
        fi

        # desktop preferences: Cinnamon
        if gsettings list-schemas | grep org.nemo.desktop &> /dev/null
        then
            gsettings set org.nemo.desktop     show-desktop-icons    true
            gsettings set org.nemo.desktop     computer-icon-visible false
            gsettings set org.nemo.desktop     home-icon-visible     false
            gsettings set org.nemo.desktop     network-icon-visible  false
            gsettings set org.nemo.desktop     trash-icon-visible    false
            gsettings set org.nemo.desktop     volumes-visible       false
            gsettings set org.nemo.preferences default-folder-viewer list-view
            gsettings set org.nemo.list-view   default-zoom-level    smallest
            # @fixme
            #gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
            #gsettings set org.gnome.desktop.interface    font-name             'Ubuntu 10'
            #gsettings set org.gnome.desktop.interface   document-font-name    'Sans 11'
            #gsettings set org.gnome.nautilus.desktop    font                  ''
        fi
        
        # desktop preferences: Gnome/Unity
        if gsettings list-schemas | grep org.gnome.nautilus.preferences &> /dev/null
        then
            gsettings set org.gnome.desktop.background   show-desktop-icons    true
            gsettings set org.gnome.nautilus.desktop     computer-icon-visible false
            gsettings set org.gnome.nautilus.desktop     home-icon-visible     false
            gsettings set org.gnome.nautilus.desktop     network-icon-visible  false
            gsettings set org.gnome.nautilus.desktop     trash-icon-visible    false
            gsettings set org.gnome.nautilus.desktop     volumes-visible       false
            gsettings set org.gnome.nautilus.preferences default-folder-viewer list-view
            gsettings set org.gnome.nautilus.list-view   default-zoom-level    smallest
            gsettings set org.gnome.desktop.interface    monospace-font-name   'Ubuntu Mono 11'
            gsettings set org.gnome.desktop.interface    font-name             'Ubuntu 10'
            #gsettings set org.gnome.desktop.interface   document-font-name    'Sans 11'
            #gsettings set org.gnome.nautilus.desktop    font                  ''
        fi
        
        # gedit preferences
        if gsettings list-schemas | grep org.gnome.gedit.preferences.editor &> /dev/null
        then
            gsettings set org.gnome.gedit.preferences.editor tabs-size 4
            gsettings set org.gnome.gedit.preferences.editor insert-spaces true
            gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
            gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
            gsettings set org.gnome.gedit.preferences.editor auto-indent true
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

#############
## CLEANUP ##
#############

unset home_bin


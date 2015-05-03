#!/bin/bash

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
        if [[ $OSTYPE == darwin* ]]
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

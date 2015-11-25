# determine the possible tag from the abbrev rev
_lp_git_branch()
{
    [[ "$LP_ENABLE_GIT" != 1 ]] && return

    \git rev-parse --inside-work-tree >/dev/null 2>&1 || return

    local branch
    # Recent versions of Git support the --short option for symbolic-ref, but
    # not 1.7.9 (Ubuntu 12.04)
    if branch="$(\git symbolic-ref -q HEAD)"; then
        _lp_escape "${branch#refs/heads/}"
    else
        # In detached head state, use commit instead
        # No escape needed
        local rev=$(\git rev-parse --short -q HEAD)
        local tag
        if tag=$(\git describe --tags --abbrev --exact-match ${rev} 2> /dev/null); then
          echo $tag
        else
          echo $rev
        fi
    fi
}

_lp_phpbrew()
{
    local php_version

    if [[ `command -v php` != /usr/bin/php ]]
    then
        php_version=`phpbrew_current_php_version 2> /dev/null`
        php_version=`_lp_escape $php_version`
        php_version="{$php_version}"
        php_version="`_lp_sl $php_version`"

        echo "${LP_COLOR_PHPBREW}${php_version}${NO_COL}"
    fi
}

prompt_tag()
{
    local tag="$(_lp_sr "$(for w in $@; do echo -n " #$w"; done)")"

    # set the tag in the prompt
    export LP_PS1_TAG="${LP_COLOR_TAG}${tag}${NO_COL}"

    # set the window title
    case "${TERM}" in
        xterm*)
            [[ -n "${tag}" ]] && echo -ne "\033]0;${tag}\007" || echo -ne "\033]0;Terminal\007"
            ;;
    esac
}


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
        if tag=$(\git describe --abbrev --exact-match ${rev} 2> /dev/null); then
          echo $tag
        else
          echo $rev
        fi
    fi
}

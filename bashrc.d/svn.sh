#!/bin/bash

#########
## SVN ##
#########

# create an alias to ease the svn:ignore property configuration
function svn-ignore()
{
    local path="${1:-.}"

    EDITOR="nano" svn propedit svn:ignore "${path}"
}

# show file affected from the commits from the given date and containing the given string in the comment
function svn-affected()
{
    local contains=$1
    local from=$2

    for rev in `svn log -r {${from}}:{$(date +%Y-%m-%d)} \
        | \grep "#${contains}" -B2 \
        | \grep ^r \
        | cut -b-6`; do svn log -v -$rev; done \
        | \grep '^   ' \
        | cut -b6- \
        | sort \
        | uniq
}

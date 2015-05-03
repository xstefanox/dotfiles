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

# alias the original svn command to add coloring and automatic proxy management
if which svn &> /dev/null
then

    if which colorsvn &> /dev/null
    then
        colorsvn=true
    fi

    proxy=${HTTP_PROXY:-${http_proxy}}
    noproxy=${NO_PROXY:-${no_proxy}}

    # if a global proxy configuration exists
    if [[ -n "${proxy}" ]]
    then
        # parse the proxy string
        proxy=( `parse_uri "${proxy}"` )

        # if proxy exceptions are configured
        if [[ -n "${noproxy}" ]]
        then

            # split the noproxy string into an array
            IFS=', ' read -a noproxy <<< "${noproxy}"

            noproxy_svn=""

            # create a comma separated string of exceptions, prepending hostnames with the * wildcard
            for item in ${noproxy[@]}
            do
                if valid_ip "${item}"
                then
                    noproxy_svn+=" ${item},"
                else
                    noproxy_svn+=" *.${item},"
                fi
            done

            noproxy="--config-option servers:global:http-proxy-exceptions='$noproxy_svn'"

            unset item noproxy_svn
        fi

        # create the alias, appending proxy host, port and exceptions (authentication not supported)
        alias svn="`[[ $colorsvn == true ]] && echo colorsvn || echo svn` --config-option servers:global:http-proxy-host='${proxy[3]}' --config-option servers:global:http-proxy-port='${proxy[4]}' $noproxy"

    else
        if [[ $colorsvn == true ]]
        then
            alias svn=colorsvn
        fi
    fi

    unset proxy noproxy colorsvn
fi

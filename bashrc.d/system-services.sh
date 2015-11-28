#!/bin/bash

########################
## SERVICE MANAGEMENT ##
########################

## Linux
if [[ $OSTYPE == linux* ]]
then
    # define a wrapper arount service and start/restart/stop commands
    function _service_manager()
    {
        local action=$1
        local svc=$2

        [[ -z $action ]] && echo 'The action is needed' && return 1
        [[ -z $svc ]] && echo 'The service name is needed' && return 1

        # on upstart based distros (Ubuntu and derivatives), try 'upstart' and fallback to 'service'
        if command -v _upstart_jobs &> /dev/null
        then
            if [[ $UID != 0 ]]
            then
                _upstart_jobs | grep --silent $svc && sudo $action $svc || sudo service $svc $action
            else
                _upstart_jobs | grep --silent $svc && $action $svc || service $svc $action
            fi
        # on Debian-based distros
        elif command -v invoke-rc.d &> /dev/null
        then
            if [[ $UID != 0 ]]
            then
                sudo invoke-rc.d $svc $action
            else
                invoke-rc.d $svc $action
            fi
        else
            if [[ $UID != 0 ]]
            then
                sudo /etc/init.d/$svc $action
            else
                /etc/init.d/$svc $action
            fi
        fi
    }

    alias start='_service_manager start'
    alias stop='_service_manager stop'
    alias restart='_service_manager restart'
    alias reload='_service_manager reload'
fi

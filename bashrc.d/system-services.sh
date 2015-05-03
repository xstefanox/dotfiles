#!/bin/bash

########################
## SERVICE MANAGEMENT ##
########################

## Linux
if [[ $OSTYPE == darwin* ]]
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

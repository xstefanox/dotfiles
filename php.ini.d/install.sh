#!/bin/bash

self="$(readlink -f $0)"

if [[ -d /etc/php5/mods-available ]]
then
    
    if [[ ! -w /etc/php5/mods-available ]]
    then
        echo "!!! Error: /etc/php5/mods-available is not writable" && exit 1
    fi

    echo -e ">>> Installing into Ubuntu-style PHP modules:\n"

    for item in $(find $(dirname "${self}") -type f -name 'x-*.ini')
    do
        echo "--> $(basename ${item})"
        ln -sf "${item}" "/etc/php5/mods-available/$(basename ${item})"
    done

    echo -e "\n>>> Done"
else
    echo "!!! Error: cannot determine PHP modules path"
fi


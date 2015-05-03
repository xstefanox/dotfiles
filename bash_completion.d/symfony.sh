#!/bin/bash

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

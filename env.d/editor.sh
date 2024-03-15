if [[ $OSTYPE == darwin* ]]
then
    if which code &> /dev/null
    then
        export EDITOR="${EDITOR:-code}"
    elif which atom &> /dev/null
    then
        export EDITOR="${EDITOR:-atom}"
    elif which mate &> /dev/null
    then
        export EDITOR="${EDITOR:-mate -w}"
    else
        export EDITOR="${EDITOR:-micro}"
    fi
elif [[ -n "$DISPLAY" ]]
then
    if which mousepad &> /dev/null
    then
        export EDITOR="${EDITOR:-mousepad}"
    elif which geany &> /dev/null
    then
        export EDITOR="${EDITOR:-geany}"
    elif which gedit &> /dev/null
    then
        export EDITOR="${EDITOR:-gedit}"
    fi
else
    export EDITOR=nano
fi

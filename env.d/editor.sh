if [[ $OSTYPE == darwin* ]]
then
    if which code &> /dev/null
    then
        export EDITOR="code"
    elif which atom &> /dev/null
    then
        export EDITOR="atom"
    elif which mate &> /dev/null
    then
        export EDITOR="mate -w"
    else
        export EDITOR=micro
    fi
elif [[ -n "$DISPLAY" ]]
then
    if which mousepad &> /dev/null
    then
        export EDITOR=mousepad
    elif which geany &> /dev/null
    then
        export EDITOR=geany
    elif which gedit &> /dev/null
    then
        export EDITOR=gedit
    fi
else
    export EDITOR=nano
fi

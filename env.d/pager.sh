if which most &> /dev/null
then
    export PAGER=most
elif which less &> /dev/null
then
    export PAGER=less
fi

export LESS="--RAW-CONTROL-CHARS"

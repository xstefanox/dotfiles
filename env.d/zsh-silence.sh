## do not shown the warning about the deault shell on macOS
## see https://support.apple.com/kb/HT208050
if [[ $OSTYPE == darwin* ]]
then
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

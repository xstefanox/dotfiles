## TERM depends on the terminal emulator, not on the session, so it must be checked by every interactive shell
## some terminals identify themselves as plain "xterm" even if they support 256 colors
if [[ "${TERM}" == xterm ]]
then
    TERM=xterm-256color
fi

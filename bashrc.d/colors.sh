## Define some useful color codes that can be used in shell scripts.
## This should be transformed in a looop that generates all the possible combinations of color codes
## and caches them in a file.

## @see http://misc.flogisoft.com/bash/tip_colors_and_formatting

# reset
NO_COLOR=`tput sgr0`
RESET=`tput sgr0`

# standard ANSI colors
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

# high intensty colors
IBLACK=`tput setaf 8`
IRED=`tput setaf 9`
IGREEN=`tput setaf 10`
IYELLOW=`tput setaf 11`
IBLUE=`tput setaf 12`
IMAGENTA=`tput setaf 13`
ICYAN=`tput setaf 14`
IWHITE=`tput setaf 15`

# bold
BOLD=`tput bold`

BBLACK=$BOLD$BLACK
BRED=$BOLD$RED
BGREEN=$BOLD$GREEN
BYELLOW=$BOLD$YELLOW
BBLUE=$BOLD$BLUE
BMAGENTA=$BOLD$MAGENTA
BCYAN=$BOLD$CYAN
BWHITE=$BOLD$WHITE

# underlined
UNDERLINED=`tput smul`
NOUNDERLINED=`tput rmul`

UBLACK=$UNDERLINED$BLACK
URED=$UNDERLINED$RED
UGREEN=$UNDERLINED$GREEN
UYELLOW=$UNDERLINED$YELLOW
UBLUE=$UNDERLINED$BLUE
UMAGENTA=$UNDERLINED$MAGENTA
UCYAN=$UNDERLINED$CYAN
UWHITE=$UNDERLINED$WHITE

# background
BACKGROUND=$RESET$(tput rev)

BGBLACK=$BACKGROUND$BLACK
BGRED=$BACKGROUND$RED
BGGREEN=$BACKGROUND$GREEN
BGYELLOW=$BACKGROUND$YELLOW
BGBLUE=$BACKGROUND$BLUE
BGMAGENTA=$BACKGROUND$MAGENTA
BGCYAN=$BACKGROUND$CYAN
BGWHITE=$BACKGROUND$WHITE

function bash_colors
{
    local i
    local color

    echo
    echo "${BOLD}normal bold underlined background tput-color-code${RESET}"

    for i in $(seq 1 7); do
        color=`tput setaf $i`
        echo " ${color}Text${RESET}  ${BOLD}${color}Text${RESET}    ${UNDERLINED}${color}Text${RESET}       ${BACKGROUND}${color}Text${RESET}           $i"
    done

    echo ' Bold                                  bold'
    echo ' Underline                             smul'
    echo ' Reset                                 sgr0'
    echo
}

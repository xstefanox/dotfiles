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
PURPLE=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`

# bold
BOLD=`tput bold`

BBLACK=$BOLD$BLACK
BRED=$BOLD$RED
BGREEN=$BOLD$GREEN
BYELLOW=$BOLD$YELLOW
BBLUE=$BOLD$BLUE
BPURPLE=$BOLD$PURPLE
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
UPURPLE=$UNDERLINED$PURPLE
UCYAN=$UNDERLINED$CYAN
UWHITE=$UNDERLINED$WHITE

# background
BACKGROUND=$RESET$(tput rev)

BGBLACK=$BACKGROUND$BLACK
BGRED=$BACKGROUND$RED
BGGREEN=$BACKGROUND$GREEN
BGYELLOW=$BACKGROUND$YELLOW
BGBLUE=$BACKGROUND$BLUE
BGPURPLE=$BACKGROUND$PURPLE
BGCYAN=$BACKGROUND$CYAN
BGWHITE=$BACKGROUND$WHITE

# high intensty
IBLACK='\033[0;90m'
IRED='\033[0;91m'
IGREEN='\033[0;92m'
IYELLOW='\033[0;93m'
IBLUE='\033[0;94m'
IPURPLE='\033[0;95m'
ICYAN='\033[0;96m'
IWHITE='\033[0;97m'

function bash_colors
{
    local i
    local color

    echo
    echo -e "${BOLD}normal bold underlined background tput-color-code${RESET}"

    for i in $(seq 1 7); do
        color=`tput setaf $i`
        echo " ${color}Text${RESET}  ${BOLD}${color}Text${RESET}    ${UNDERLINED}${color}Text${RESET}       ${BACKGROUND}${color}Text${RESET}           $i"
    done

    echo ' Bold                                  bold'
    echo ' Underline                             smul'
    echo ' Reset                                 sgr0'
    echo
}

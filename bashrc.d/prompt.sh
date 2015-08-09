## Override the standard os prompt.
## This prompt adds:
## - colored info about the username, the hostname and the current path
## - the last command return value and, in case of error, the corresponding error string as defined in the libc
## - if the current path is under version control, info about the current commit/branch/local modifications (currently supported vcs: Git, SVN, HG)
## - notification about GNU screen session
## - notification about SSH session

# prepare the color codes for the current platform
if [[ $OSTYPE == darwin* ]]
then
    P_GREEN="${GREEN}"
    P_RED="${RED}"
    P_YELLOW="${YELLOW}"
    P_BLUE="${BLUE}"
else
    P_GREEN="${BGREEN}"
    P_RED="${BRED}"
    P_YELLOW="${BYELLOW}"
    P_BLUE="${BBLUE}"
fi

# save the list of return error strings supported by the OS libc and the greatest error number
PS1_os_maxerr=133

IFS_save="${IFS}"

IFS=$'\n' PS1_os_errno=( $(cat << EOT | python - ${PS1_os_maxerr}
import sys
import os

for errno in [ os.strerror(e) for e in range(0, int(sys.argv[1]) + 1) ]:
    if sys.version_info < (2, 6):
        print errno
    else:
        print(errno)
EOT
) )

IFS="${IFS_save}"

# save the return value of the last executed process and the write permission on the current working directory
PROMPT_COMMAND='PS1_return_value=$?;[[ -w "${PWD}" ]];PS1_cwd_perm=$?'

# translate the saved return value in a colored string containing the error description
PS1_return_value='$(
    echo -ne "${NO_COLOR}(";

    if [[ "${PS1_return_value}" == 0 ]];
    then
        echo -ne "${P_GREEN}${PS1_return_value}";
    else
        echo -ne "${P_RED}${PS1_return_value}:$([[ ${PS1_return_value} -gt ${PS1_os_maxerr} ]] && echo "Unknown error" || echo "${PS1_os_errno[${PS1_return_value}]}")";
    fi

    echo -ne "${NO_COLOR})";
)'

# generate a colored string describing the status of the Git working copy in the current directory
PS1_git_status='$(
    if which git &> /dev/null && git status &> /dev/null;
    then
        echo -ne "${NO_COLOR}{";

        status="$(git status --porcelain)"

        if [[ -z "${status}" ]];
        then
            echo -ne "${P_GREEN}";
        else
            echo -ne "${P_RED}";
        fi;

        echo -n "git:$(git branch --no-color | sed -n "/^*/ s:[^ ]* :: p")";


        if [[ -n "${status}" ]];
        then
            declare -a status_info;
            added_count=$(echo "${status}" | grep "^A" | wc -l);
            deleted_count=$(echo "${status}" | grep "^\(D \| D\|D\) " | wc -l);
            modified_count=$(echo "${status}" | grep "^\(M \| M\|MM\) " | wc -l);
            untracked_count=$(echo "${status}" | grep "^??" | wc -l);
            [[ "${added_count}" -gt 0 ]] && status_info[0]="$(echo "${added_count}" | sed "s:[[:space:]]*:+:")";
            [[ "${deleted_count}" -gt 0 ]] && status_info[1]="$(echo "${deleted_count}" | sed "s:[[:space:]]*:-:")";
            [[ "${modified_count}" -gt 0 ]] && status_info[2]="$(echo "${modified_count}" | sed "s:[[:space:]]*:±:")";
            [[ "${untracked_count}" -gt 0 ]] && status_info[3]="$(echo "${untracked_count}" | sed "s:[[:space:]]*:?:")";
            echo -n "($(printf "%s/" "${status_info[@]}" | cut -d "/" -f 1-${#status_info[@]}))";
        fi;

        echo -ne "${NO_COLOR}";

        echo -n "}"
    fi
)'

# generate a colored string describing the status of the Mercurial working copy in the current directory
PS1_hg_status='$(
    if which hg &> /dev/null && hg status &> /dev/null;
    then
        echo -ne "${NO_COLOR}{";

        if [[ -z "$(hg status)" ]];
        then
            echo -ne "${P_GREEN}";
        else
            echo -ne "${P_RED}";
        fi;

        echo -n "hg:$(hg branch)";

        echo -ne "${NO_COLOR}}";
    fi
)'

# generate a colored string describing the status of the Subversion working copy in the current directory
PS1_svn_status='$(
    if which svn &> /dev/null && svn info &> /dev/null;
    then
        rev="$(LC_ALL=C svn info | sed -n "/^Revision:/ s/.*:[[:space:]]*// p")"
        status="$(svn status)"

        echo -ne "${NO_COLOR}{";

        if [[ -n "${status}" ]];
        then
            echo -ne "${P_RED}svn:${rev}";

            declare -a status_info;
            added_count=$(echo "${status}" | grep "^A" | wc -l);
            deleted_count=$(echo "${status}" | grep "^D" | wc -l);
            modified_count=$(echo "${status}" | grep "^\(M \| M\) " | wc -l);
            untracked_count=$(echo "${status}" | grep "^?" | wc -l);
            not_found_count=$(echo "${status}" | grep "!" | wc -l);
            [[ "${added_count}" -gt 0 ]] && status_info[0]="+${added_count}";
            [[ "${deleted_count}" -gt 0 ]] && status_info[1]="-${deleted_count}";
            [[ "${modified_count}" -gt 0 ]] && status_info[2]="±${modified_count}";
            [[ "${untracked_count}" -gt 0 ]] && status_info[3]="?${untracked_count}";
            [[ "${not_found_count}" -gt 0 ]] && status_info[4]="!${not_found_count}";
            echo -n "($(printf "%s/" "${status_info[@]}" | cut -d "/" -f 1-${#status_info[@]}))";
        else
            echo -ne "${P_GREEN}";

            echo -n "svn:${rev}";
        fi;

        echo -ne "${NO_COLOR}}";
    fi
)'

# generate the final version control system status description string
PS1_vcs_status="${PS1_git_status}${PS1_hg_status}${PS1_svn_status}"

# color the username depending on user being root or not
PS1_username='$(
    #if [[ -n "${SSH_CLIENT}" ]] || [[ ${USER} != "$(logname 2>/dev/null)" ]]
    #then
        if [[ $UID == 0 ]]
        then
            echo -ne "${P_RED}";
        else
            echo -ne "${P_GREEN}";
        fi

        echo -ne ${USER}${NO_COLOR}
    #fi
)'

PS1_hostname='$(
    if [[ -n "${SSH_CLIENT}" || "${PS1_hostname_on}" == 1 ]]
    then
        echo -ne "${P_YELLOW}@${HOSTNAME}${NO_COLOR}"
    fi
)'

# set an SSH descriptive string in case of a remote connection
PS1_ssh_status="$([[ -n "${SSH_CLIENT}" ]] && echo "${P_YELLOW}ssh:${NO_COLOR}")"

# set the screen status
PS1_screen_status="$([[ -n "${STY}" ]] && echo "[${P_YELLOW}screen:${P_BLUE}$(echo "${STY#*.}" | sed -e "s:.${HOSTNAME}::")${NO_COLOR}]")"

# set the shell tag
PS1_hashtag='$([[ -n "${PS1_tag}" ]] && echo " ${CYAN}#${PS1_tag}${NO_COLOR}")'

# set a colored colon depending on the write permissions on the current working directory
PS1_cwd_perm='$(
    echo -ne "${NO_COLOR}";

    if [[ "${PS1_cwd_perm}" == 0 ]];
    then
        echo -ne "${P_GREEN}";
    else
        echo -ne "${P_RED}";
    fi

    echo -ne ":${NO_COLOR}";
)'

# set a descriptive string about jobs
PS1_jobs='$(

    running="$(( $(jobs -r | wc -l) ))"
    stopped="$(( $(jobs -s | wc -l) ))"
    detached="$(which screen &> /dev/null && { screen -ls 2> /dev/null | grep -c Detach; true; } || echo 0)"
    ret=""

    if [[ $detached != "0" ]]
    then
        ret="${ret}${YELLOW}${detached}d${NO_COLOR}"
    fi

    if [[ $running != "0" ]]
    then
        if [[ $ret != "" ]]
        then
            ret="${ret}/"
        fi
        ret="${ret}${YELLOW}${running}&${NO_COLOR}"
    fi

    if [[ $stopped != "0" ]]
    then
        if [[ $ret != "" ]]
        then
            ret="${ret}/"
        fi
        ret="${ret}${YELLOW}${stopped}z${NO_COLOR}"
    fi

    [[ -n "${ret}" ]] && echo -ne " ${ret}"
)'

PS1_cwd="${P_BLUE}\w${NO_COLOR}"

## PS1: Default prompt
PS1="${NO_COLOR}${PS1_screen_status}[${PS1_ssh_status}${PS1_username}${PS1_hostname}${PS1_cwd_perm}${PS1_cwd}]${PS1_return_value}${PS1_vcs_status}${PS1_jobs}${PS1_hashtag}\n\$ "

# clean the environment
unset PS1_return_value PS1_git_status PS1_hg_status PS1_svn_status PS1_vcs_status PS1_ssh_status PS1_screen_status PS1_username PS1_hostname PS1_cwd_perm PS1_hashtag PS1_jobs PS1_cwd

## Use Bash defaults for continuation prompt (PS2) and select prompt (PS3)

## PS4: Debug prompt
PS4='$0, Line $LINENO: '

# set/unset the tag string
function prompt-tag()
{
    local IFS=

    # save the tag
    export PS1_tag="$(echo $@ | sed -e 's:#\{1,\}: :g' -e 's:^[[:space:]]*::' -e 's:[[:space:]]\{1,\}: :g')"

    # set the window title
    case "${TERM}" in
        xterm*)
            [[ -n "${PS1_tag}" ]] && echo -ne "\033]0;#${PS1_tag}\007" || echo -ne "\033]0;Terminal\007"
            ;;
    esac
}

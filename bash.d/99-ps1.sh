#!/bin/bash

_update_ps1() {
    local exit_status=$?

    # basic terminal colors
    local black="\[\033[38;5;0m\]"
    local red="\[\033[38;5;1m\]"
    local orange="\[\033[38;5;3m\]"
    local green="\[\033[38;5;2m\]"
    local blue="\[\033[38;5;4m\]"
    local purple="\[\033[38;5;5m\]"
    local cyan="\[\033[38;5;6m\]"
    local white="\[\033[38;5;7m\]"

    # extended colors
    local acid="\[\033[38;5;194m\]"
    local android="\[\033[38;5;79m\]"
    local azure="\[\033[38;5;123m\]"
    local banana="\[\033[38;5;184m\]"
    local burnt="\[\033[38;5;172m\]"
    local deep_red="\[\033[38;5;196m\]"
    local electric_blue="\[\033[38;5;39m\]"
    local grey_offwhite="\[\033[38;5;249m\]"
    local indigo="\[\033[38;5;63m\]"
    local lavender="\[\033[38;5;105m\]"
    local lilac="\[\033[38;5;153m\]"
    local lime="\[\033[38;5;154m\]"
    local magenta="\[\033[38;5;207m\]"
    local midnight="\[\033[38;5;69m\]"
    local pink="\[\033[38;5;219m\]"
    local rose="\[\033[38;5;225m\]"
    local sky_blue="\[\033[38;5;45m\]"
    local tan="\[\033[38;5;231m\]"
    local tangerine="\[\033[38;5;214m\]"

    # styles
    local subtle=$grey_offwhite
    local danger=$deep_red
    local warning=$orange
    local attention=$purple

    local git_dirty_style=$red
    local git_warn_style=$orange
    local git_new_style=$cyan
    local git_clean_style=$green
    local git_stash_style=$sky_blue

    local cwd_style=$lilac
    local jobs_style=$tangerine
    local dirs_style=$electric_blue
    local user_style=$acid

    # reset
    local off="\[\033[0m\]"

    # surround, join, and space helper functions
    surround_ne() {
        # surround if non-empty
        # $1: a length 2 string containing left/right surround chars e.g. () {} <>
        # $2: the thing to test and surround if non-empty
        if [ -z "$2" ]; then
            echo ""
            return
        fi

        ls=${1:0:1}
        rs=${1:1:1}
        echo "${ls}${2}${rs}"
    }

    join() {
        # join two strings with a delimiter, testing whether either/both are empty first
        # $1: the delimiter
        # $2: left str
        # $3: right str
        if [ -n "$2" -a -n "$3" ]; then
            echo "$2$1$3"
        elif [ -z "$2" -a -n "$3" ]; then
            echo "$3"
        elif [ -n "$2" -a -z "$3" ]; then
            echo "$2"
        fi
    }

    prefix_ne() {
        if [ -n "$2" ]; then
            if [ -n "$1" ]; then
                echo "$1$2"
            else
                echo " $1"
            fi
        fi
    }

    suffix_ne() {
        if [ -n "$2" ]; then
            if [ -n "$1" ]; then
                echo "$2$1"
            else
                echo "$1 "
            fi
        fi
    }

    blank_if_zero() {
        if [ $1 -eq 0 ]; then
            echo ""
        else
            echo $1
        fi
    }

    colorize() {
        if [ -n "$2" ]; then
            echo "${1}${2}${off}"
        fi
    }

    # various elements
    virtualenv_name() {
        if [ -n "$VIRTUAL_ENV" ]; then
            echo $(basename $VIRTUAL_ENV)
        fi
    }

    git_prompt() {
        gitps1=$(__git_ps1)
        echo $gitps1 | tr -d '()'
    }

    stash_length() {
        echo $(git stash list 2> /dev/null | wc -l)
    }

    git_status() {
        if [[ $(git st -s 2> /dev/null | grep -e "^\s*[DM]" | wc -l | awk '{ print $1 }') != "0" ]]; then
            echo "modified"
        elif [[ $(git st --porcelain 2> /dev/null | wc -l | awk '{ print $1 }') != "0" ]]; then
            echo "untracked"
        else
            echo "clean"
        fi
    }

    git_branch_color() {
        local gs=$(git_status)
        if [[ $gs == "modified" ]]; then
            gitcolor=$git_dirty_style
        elif [[ $gs == "untracked" ]]; then
            gitcolor=$git_new_style
        else
            gitcolor=$git_clean_style
        fi
        echo $gitcolor
    }

    # PS1 components
    git_branch_cmp() {
        local gitcolor=$1
        # get stash
        if [[ $(stash_length) == "0" ]]; then
            stashprompt=""
        else
            stashprompt="$(colorize $git_stash_style "@$(stash_length)")${gitcolor}"
        fi

        # get branch
        local branchname=$(git_prompt)
        if [[ $branchname == *"|"* ]]; then
            # if the branch name has something like |^REBASE in it
            local gitstate=$(colorize $git_warn_style ^$(echo $branchname | cut -d'|' -f2))${gitcolor}
            local branchname=$(echo $branchname | cut -d'|' -f1)
            local gitprompt=${branchname}${gitstate}
        else
            local gitprompt=$branchname
        fi
        echo "${gitprompt}${stashprompt}"
    }

    venv_branch_cmp() {
        local gitcolor=$(git_branch_color)
        local venv=$(virtualenv_name)
        local gp=$(git_branch_cmp $gitcolor)

        # in case we want to show multiple environments e.g. node version
        local env_name=`join "." $venv`
        local joined=`join "$subtle|$gitcolor" $env_name ${gp}`
        echo $(colorize $gitcolor "`suffix_ne ' ' $(surround_ne '{}' $joined)`")
    }

    user_host_cmp() {
        declare -A host_colors
        host_colors=([claudia]=$android [retro]=$burnt [jdhillon-mbp.local]=$purple)
        if [[ ${host_colors[$HOSTNAME]} ]]; then
            host_color=${host_colors[$HOSTNAME]}
        else
            if [[ $TERM =~ "256color"  ]]; then
                host_color="\[\033[38;5;$((16 + $(hostname | cksum | cut -c1-3) % 216))m\]";
            else
                host_color="\[\033[1;$((31 + $(hostname | cksum | cut -c1-3) % 6))m\]";
            fi
        fi

        if [[ $USER == "root" ]]; then
            local userhost=$(colorize $danger "\u${off}${host_color}@\h")
        else
            local userhost=$(colorize $user_style "\u${off}${host_color}@\h")
        fi
        echo $userhost
    }

    cwd_cmp() {
        echo $(colorize $cwd_style "\w")
    }

    prompt_cmp() {
        local status=$1

        local pc='$'
        if [[ $UID == "0" ]]; then
            pc='#'
        fi

        if [[ $status == "0" ]]; then
            echo $(colorize $subtle $pc)
        else
            echo $(colorize $danger $pc)
        fi
    }

    jobs_cmp() {
        echo $(colorize $jobs_style $(prefix_ne "%" `blank_if_zero $(jobs | wc -l)`))
    }

    dirs_cmp() {
        echo $(colorize $dirs_style $(suffix_ne "#" `blank_if_zero $(dirs -v | cut -d' ' -f2 | sort -nr | head -1)`))
    }

    timestamp_cmp() {
        echo $(colorize $subtle "[`date +"%H:%M"`]")
    }

    # render pipeline
    local cmps=( "$(timestamp_cmp) "
                 "$(venv_branch_cmp)"
                 $(user_host_cmp)
                 $(jobs_cmp)
                 "${subtle}:${off}"
                 $(dirs_cmp)
                 $(cwd_cmp)
                 $(prompt_cmp $exit_status) )
    local IFS=
    export PS1="${cmps[*]}${off} "
}

foreground() {
    # updates title when resuming jobs
    extglob_state=$(shopt -p extglob)
    shopt -s extglob
    case "$1" in
        [0-9]*[0-9])
            jobname=$(jobs | grep -e "^\[$1\]" | awk '{$1=$2=""; print $0}');;
        +|-)
            jobname=$(jobs | grep -e "^\[[[:digit:]]\+\]$1" | awk '{$1=$2=""; print $0}');;
        *)
            jobname=$(jobs | grep -e "^\[[[:digit:]]\+\]+" | awk '{$1=$2=""; print $0}');;
    esac
    $extglob_state
    printf "\033]2;%s\033\\" "${jobname##*( )}";
    \fg $1
}
alias fg=foreground

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} '_update_ps1')

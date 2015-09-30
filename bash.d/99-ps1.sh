#!/bin/bash

_update_ps1() {
local black="\[\033[0;30m\]"
local grey="\[\033[1;30m\]"
local blue="\[\033[0;34m\]"
local cyan="\[\033[0;36m\]"
local green="\[\033[0;40m\]"
local red="\[\033[0;31m\]"
local purple="\[\033[0;35m\]"
local brown="\[\033[0;33m\]"
local yellow="\[\033[1;33m\]"
local white="\[\033[1;37m\]"

local positive_green="\[\033[38;5;64m\]"
local lime="\[\033[38;5;148m\]"
local pale_green="\[\033[38;5;191m\]"
local electric_blue="\[\033[38;5;39m\]"
local sky_blue="\[\033[38;5;81m\]"
local scarlet="\[\033[38;5;9m\]"
local dark_grey="\[\033[38;5;238m\]"
local lavender="\[\033[38;5;59m\]"
local light_cyan="\[\033[1;36m\]"
local light_blue="\[\033[1;34m\]"
local light_green="\[\033[1;32m\]"
local light_red="\[\033[1;31m\]"
local light_purple="\[\033[38;5;183m\]"
local light_grey="\[\033[0;37m\]"
local orange="\[\033[38;5;208m\]"

local warning="\[\033[1;30m\]\[\033[48;5;208m\]"
local danger="\[\033[38;5;195m\]\[\033[48;5;196m\]"
local off="\[\033[0m\]"

angle_if() {
    if [ -z "$1" ]; then
        echo ""
        return
    fi

    echo "<$1>"
    return
}

bracket_if() {
    if [ -z "$1" ]; then
        echo ""
        return
    fi

    echo "{$1}"
    return
}

parens_if() {
    if [ -z "$1" ]; then
        echo ""
        return
    fi

    echo "($1)"
    return
}

git_prompt() {
    gitps1=$(__git_ps1)
    echo $gitps1 | tr -d '()'
}

stash_length() {
    echo $(git stash list 2> /dev/null | wc -l)
}

git_status() {
    if [[ $(git st -s 2> /dev/null | grep -e "^\s*[DM]" | wc -l) != "0" ]]; then
        echo "modified"
    elif [[ $(git st --porcelain 2> /dev/null | wc -l) != "0" ]]; then
        echo "untracked"
    else
        echo "clean"
    fi
}

join() {
    if [ -n "$2" -a -n "$3" ]; then
        echo "$2$1$3"
    elif [ -z "$2" -a -n "$3" ]; then
        echo "$3"
    elif [ -n "$2" -a -z "$3" ]; then
        echo "$2"
    fi
}

virtualenv_name() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo $(basename $VIRTUAL_ENV)
    fi
}

prepend_if() {
    if [ -n "$2" ]; then
        if [ -n "$1" ]; then
            echo "$1$2"
        else
            echo " $1"
        fi
    fi
}

append_if() {
    if [ -n "$2" ]; then
        if [ -n "$1" ]; then
            echo "$2$1"
        else
            echo "$1 "
        fi
    fi
}

colorize() {
    if [ -n "$2" ]; then
        echo "$1$2$off"
    fi
}

gem_set_name () {
    [[ "$GEM_HOME" =~ .+@.+ ]] && echo $GEM_HOME | cut -d'@' -f2
}

blank_if_zero() {
    if [ $1 -eq 0 ]; then
        echo ""
    else
        echo $1
    fi
}

    declare -A host_colors
    host_colors=([jdhillon-x1]=$light_purple)
    if [[ ${host_colors[$HOSTNAME]} ]]; then
        host_color=${host_colors[$HOSTNAME]}
    else
        if [[ $TERM =~ "256color"  ]]; then
            host_color="\[\033[38;5;$((16 + $(hostname | cksum | cut -c1-3) % 216))m\]";
        else
            host_color="\[\033[1;$((31 + $(hostname | cksum | cut -c1-3) % 6))m\]";
        fi
    fi

    declare -A awshash
    awshash=([production]=prod [development]=dev [uat]=uat [integration2]=i2 [integration3]=i3)
    awsenv=""
    if [[ $AWS_ENVIRONMENT && ${awshash[$AWS_ENVIRONMENT]} ]]; then
        awsenv=${awshash[$AWS_ENVIRONMENT]}
        if [[ $awsenv == "prod" ]]; then
            awscolor=$danger
        else
            awscolor=$lavender
        fi
    fi

    gs=$(git_status)
    if [[ $gs == "modified" ]]; then
        gitcolor=$scarlet
    elif [[ $gs == "untracked" ]]; then
        gitcolor=$electric_blue
    else
        gitcolor=$positive_green
    fi

    [[ $(stash_length) == "0" ]] && stashprompt="" || stashprompt="$(colorize $sky_blue "@$(stash_length)")${gitcolor}"

    local venv=$(virtualenv_name)
    local gemset=$(gem_set_name)
    local branchname=$(git_prompt)

    if [[ $branchname == *"|"* ]]; then
        local gitstate=$(colorize $orange ^$(echo $branchname | cut -d'|' -f2))${gitcolor}
        local branchname=$(echo $branchname | cut -d'|' -f1)
        local gitprompt=${branchname}${gitstate}
    else
        local gitprompt=$branchname
    fi

    local env_name=`join "." $venv $gemset`
    local joined=`join "$dark_grey|$gitcolor" $env_name ${gitprompt}${stashprompt}`
    local bracketed=$(colorize $gitcolor "`append_if ' ' $(bracket_if $joined)`")

    local userhost=$(colorize $brown "\u${host_color}@\h")
    local cwd=$(colorize $cyan "\w")
    local prompt=$(colorize $cyan '>')

    local jobscount=$(colorize $lime $(prepend_if "%" `blank_if_zero $(jobs | wc -l)`))
    local dirscount=$(colorize $blue $(append_if "#" `blank_if_zero $(dirs -v | cut -d' ' -f2 | sort -nr | head -1)`))

    local timestamp=$(colorize $dark_grey "[`date +"%H:%M"`]")
    local awsenv=$(colorize $awscolor "`append_if "$off " $(prepend_if "#" ${awsenv})`")

    export PS1="${timestamp} ${awsenv}${bracketed}${userhost}${jobscount}${dark_grey}:${dirscount}${cwd}${prompt}${off} "
}

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} '_update_ps1')

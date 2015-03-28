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

local lime="\[\033[38;5;148m\]"
local pale_green="\[\033[38;5;191m\]"
local sky_blue="\[\033[38;5;51m\]"
local scarlet="\[\033[38;5;9m\]"
local dark_grey="\[\033[38;5;240m\]"
local light_cyan="\[\033[1;36m\]"
local light_blue="\[\033[1;34m\]"
local light_green="\[\033[1;32m\]"
local light_red="\[\033[1;31m\]"
local light_purple="\[\033[1;35m\]"
local light_grey="\[\033[0;37m\]"

local lavender="\e[38;5;104m"

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

git_status() {
    echo $(git st -s 2> /dev/null | wc -l)
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
    [[ $(git_status) == "0" ]] && gitcolor=$pale_green || gitcolor=$scarlet

    local venv=$(virtualenv_name)
    local gemset=$(gem_set_name)
    local gitprompt=$(git_prompt)
    local env_name=`join "." $venv $gemset`
    local joined=`join "$dark_grey|$gitcolor" $env_name $gitprompt`
    local bracketed=$(colorize $gitcolor "`append_if ' ' $(bracket_if $joined)`")

    local userhost=$(colorize $brown "\u@\h")
    local cwd=$(colorize $cyan "\w")
    local prompt=$(colorize $cyan '>')

    local jobscount=$(colorize $lime $(prepend_if "%" `blank_if_zero $(jobs -s | wc -l)`))
    local dirscount=$(colorize $blue $(append_if "#" `blank_if_zero $(dirs -v | cut -d' ' -f2 | sort -nr | head -1)`))

    local timestamp=$(colorize $dark_grey "[`date +"%H:%M"`]")

    export PS1="$timestamp $bracketed$userhost$jobscount:$dirscount$cwd$prompt$off "
}

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} '_update_ps1')

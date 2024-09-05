#!/bin/bash

if [ -n "$TMUX" ]; then
  function refresh {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK") > /dev/null
    export $(tmux show-environment | grep "^SSH_CONNECTION") > /dev/null
    export $(tmux show-environment | grep "^XAUTHORITY") > /dev/null
    export $(tmux show-environment | grep "^DISPLAY") > /dev/null
    export $(tmux show-environment | grep "^GNOME_TERMINAL_SCREEN") > /dev/null
  }
  trap refresh DEBUG
fi

case ${TERM} in
    tmux-*)
        # user command to change default pane title on demand
        function pane_title { TMUX_PANE_TITLE="$*"; }

        # function that performs the title update (invoked as PROMPT_COMMAND)
        # function update_title { printf "\033]2;%s\033\\" "${1:-$TMUX_PANE_TITLE}"; }
        function _update_title {
            if [ "${1:-$TMUX_PANE_TITLE}" = "_update_ps1" ]; then
                printf "\033]2;%s\033\\" "bash";
            else
                printf "\033]2;%s\033\\" "${1:-$TMUX_PANE_TITLE}";
            fi
        }

        # default pane title is the name of the current process (i.e. 'bash')
        TMUX_PANE_TITLE=$(ps -o comm $$ | tail -1)

        # Reset title to the default before displaying the command prompt
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'_update_title'

        # Update title before executing a command: set it to the command
        trap '_update_title "$BASH_COMMAND"' DEBUG
        ;;
esac

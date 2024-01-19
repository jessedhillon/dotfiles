#!/bin/bash

if [ -n "$TMUX" ]; then
  function refresh {
    export $(tmux show-environment | grep "^SSH_AUTH_SOCK") > /dev/null
    export $(tmux show-environment | grep "^DISPLAY") > /dev/null
    export $(tmux show-environment | grep "^GNOME_TERMINAL_SCREEN") > /dev/null
  }
  trap refresh DEBUG
fi

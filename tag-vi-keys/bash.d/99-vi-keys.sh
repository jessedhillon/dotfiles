# set vi mode
set -o vi

stty -ixon  # disables flow control, which prevents ctrl+s from being bound (readling cycle forward)

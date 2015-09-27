function venv_prompt()
{
  DIR=$PWD
  while true; do
    if [ -e "${DIR}/.virtualenv" ]; then
      VENV=$(cat ${DIR}/.virtualenv)
      if [ -z "$VIRTUAL_ENV" ]; then
          workon `cat ${DIR}/.virtualenv`
          wait $!
      elif [ "$(basename $VIRTUAL_ENV)" != "$VENV" ]; then
          workon `cat ${DIR}/.virtualenv`
          wait $!
      fi
      break
    fi

    if [ "$DIR" == "/" ]; then
      if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
        wait $!
      fi
      break
    fi

    DIR=$(dirname $DIR)
  done
}

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} 'venv_prompt')

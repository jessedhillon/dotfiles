function venv_prompt()
{
  DIR=$PWD
  while true; do
    if [ -e "${DIR}/.virtualenv" ]; then
      workon `cat ${DIR}/.virtualenv`
      break
    fi

    if [ "$DIR" == "/" ]; then
      if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
      fi
      break
    fi

    DIR=$(dirname $DIR)
  done
}

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} 'venv_prompt')

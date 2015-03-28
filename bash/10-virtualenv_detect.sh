function venv_prompt()
{
  if [ "$PWD" != "$OLDPWD" ]; then
    OLDPWD="$PWD"
    test -e .virtualenv && workon `cat .virtualenv`
  fi
}

PROMPT_COMMANDS=(${PROMPT_COMMANDS[@]} 'venv_prompt')

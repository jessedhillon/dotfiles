if [[ $OSTYPE =~ ^darwin ]]; then
    export PATH=/opt/local/bin:$PATH

    if [ -f /opt/local/etc/bash_completion ]; then
        . /opt/local/etc/bash_completion
    fi

    if [ -f /opt/local/share/git/contrib/completion/git-completion.bash ]; then
        . /opt/local/share/git/contrib/completion/git-completion.bash
    fi

    if [ -f /opt/local/share/git/contrib/completion/git-prompt.sh ]; then
        . /opt/local/share/git/contrib/completion/git-prompt.sh
    fi

    alias ls="ls -h -G"
fi

if [ -f /opt/local/bin/virtualenvwrapper.sh-3.6 ]; then
    export VIRTUALENVWRAPPER_PYTHON='/opt/local/bin/python3.6'
    export VIRTUALENVWRAPPER_VIRTUALENV='/opt/local/bin/virtualenv-3.6'
    export VIRTUALENVWRAPPER_VIRTUALENV_CLONE='/opt/local/bin/virtualenv-clone-3.6'
    source /opt/local/bin/virtualenvwrapper.sh-3.6
fi

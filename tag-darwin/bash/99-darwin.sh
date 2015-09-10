if [[ $OSTYPE =~ ^darwin ]]; then
    if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
        . /usr/local/git/contrib/completion/git-completion.bash
    fi

    alias ls="ls -h -G"
fi

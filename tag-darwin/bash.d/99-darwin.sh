if [[ $OSTYPE =~ ^darwin ]]; then
    if [ -f /usr/local/etc/bash_completion ]; then
        . /usr/local/etc/bash_completion
    fi

    if [ -f /usr/local/git/contrib/completion/git-completion.bash ]; then
        . /usr/local/git/contrib/completion/git-completion.bash
    elif [ -f $(xcode-select -p)/usr/share/git-core/git-completion.bash ]; then
        . $(xcode-select -p)/usr/share/git-core/git-completion.bash
    fi

    if [ -f $(xcode-select -p)/usr/share/git-core/git-prompt.sh ]; then
        . $(xcode-select -p)/usr/share/git-core/git-prompt.sh
    fi

    alias ls="ls -h -G"
    alias vim="mvim -v"
    if [ -x /Applications/Xcode.app/Contents/Developer/usr/bin/git ]; then
        alias git="/Applications/Xcode.app/Contents/Developer/usr/bin/git"
    fi
fi

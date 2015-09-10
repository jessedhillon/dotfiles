if [[ "$-" =~ *i* ]]; then
    if [ -e ~/.Xmodmap ]; then
        sleep 4 && xmodmap ~/.Xmodmap
    fi
fi

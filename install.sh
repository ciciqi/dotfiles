#!/usr/bin/env bash

files="zshrc aliases tmux.conf vimrc gitconfig"

for file in $files; do
    origin="$HOME/.$file"
    [[ -f "$origin" ]] && mv "$origin" "$origin.old";
    echo "move $origin to $origin.old"

    file="$(pwd)/$file"
    [[ -r "$file" ]] && [[ -f "$file" ]] && ln -s -T "$file" "$origin";
    echo "link $file to $origin"
done

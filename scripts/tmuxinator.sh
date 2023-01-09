#!/usr/bin/env bash

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='---TMUXINATOR---'"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

current_session=$(tmux display-message -p | sed -e 's/^\[//' -e 's/\].*//')
target=$(ls ~/.config/tmuxinator | sed -E 's/\..*$//' | sed -E "s/$current_session/*$current_session/" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")

[[ "$target" == "[cancel]" || -z "$target" ]] && exit
if [[ -n $(echo "$target" | grep -o "copy-mode") && -z $(echo "$target" | grep -o "prefix") ]]; then
    echo "$target" | xargs tmuxinator start
else
    echo "$target" | xargs tmuxinator start
fi

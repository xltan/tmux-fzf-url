#!/usr/bin/env bash

fzf_cmd() {
    fzf-tmux -p 40% -m -1
}

if hash xdg-open &>/dev/null; then
    open_cmd='xdg-open'
elif hash open &>/dev/null; then
    open_cmd='open'
fi

content="$(tmux capture-pane -J -p)"

urls=($(echo "$content" |grep -oE '(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'))
wwws=($(echo "$content" |grep -oE 'www\.[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*'                  |sed 's/^\(.*\)$/http:\/\/\1/'))
ips=($(echo  "$content" |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*' |sed 's/^\(.*\)$/http:\/\/\1/'))

items=$(printf '%s\n' "${urls[@]}" "${wwws[@]}" "${ips[@]}" | grep -v '^$' | sort -u | nl -w3 -s '  ')

[ -z "$items" ] && exit

fzf_cmd <<< $items | awk '{print $2}'| xargs -n1 -I {} $open_cmd {} >/dev/null || true

#!/bin/bash

htrash=~/.trash
hlog=~/.trash.log

if [[ $# -ne 1 ]]; then
        echo "Only one filename was expected, not $#."
        exit 1
fi

if [[ ! -f $1 ]]; then
        echo "$1 is not a file or does not exist in current directory."
        exit 1
fi

if [[ ! -d $htrash ]]; then
        mkdir $htrash
fi
curfile=$(date +%s%N)

ln $1 "$htrash/$curfile"

rm $1

if [[ ! -f $hlog ]]; then
        touch $hlog
fi

echo "$PWD/$1_$curfile" >> $hlog

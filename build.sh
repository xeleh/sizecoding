#!/bin/bash

# $1    : name of the folder to build
# $2... : (optional) additional args to be passed to nasm
# Make sure that nasm is on the PATH!

# fail if no folder name is specified
if [[ "$#" -eq 0 ]] ; then
    echo "no folder specified" >&2 && exit 1
fi

# fail if specified folder does not exist
if [[ ! -d "$1" ]] ; then
    echo "folder '$1' does not exist" >&2 && exit 1
fi

# try to find the main .asm file
file="$1"
[ ! -f "$1/$file.asm" ] && file="${file/[/}" && file="${file/]/}"
[ ! -f "$1/$file.asm" ] && file="main"
[ ! -f "$1/$file.asm" ] && file="test"
[ ! -f "$1/$file.asm" ] && exit 1

# assemble it
if command -v nasm &> /dev/null ; then
    nasm -i "$1" -w+error "${@:2}" -f bin -o "$1/$file.com" "$1/$file.asm" || exit 1
else
    echo "nasm not on path?" >&2 && exit 1
fi

# show .com file size
if [[ -f "$1/$file.com" ]] ; then
    size=$(stat -f%z "$1/$file.com")
    echo "$1/$file.com" : "$size" bytes
fi

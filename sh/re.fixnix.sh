#!/bin/bash


function help() {
    printf "Usage: %s <file|directory>\n" $0
}


function main() {
    arg=$1
    printf "Fixing %s...\n" $arg
    find $arg -type f |while read f; do
        chmod -v -x $f
        chflags uchg $f
    done

    find $arg -type f |while read f; do
        ls -alO $f
    done
}


if [[ $# -ne 1 ]]; then
    help $0
    exit -1
fi

main $1

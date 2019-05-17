#!/bin/bash

IMAGEJ="ImageJ-linux64 --headless --default-gc"

set -e

if [[ $# -eq 0 ]] ; then
    if [ -t 0 ] ; then
        exec bash
    else
        exec $IMAGEJ --help
    fi
else
    exec $IMAGEJ "$@"
fi

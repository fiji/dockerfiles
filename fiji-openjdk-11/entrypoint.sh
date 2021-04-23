#!/bin/bash
#
# Entrypoint for the docker image which tries to do
# the most sensible thing for the user:
#
#   (A) If no arguments are passed, print help:
#   $ docker run fiji
#
#   (B) If no arguments are passed but a ternimal is requested, open a shell:
#   $ docker run -ti fiji
#
#   (C) Otherwise, assume arguments are to be passed to ImageJ-linux64:
#   $ docker run fiji --console --run /my/script.py
#
#   (D) Unless, the command starts with an executable, in which case run it:
#   $ docker run fiji ImageJ-linux64 --console --run /my/script.py

# Command run by default
IMAGEJ=${IMAGEJ:-"ImageJ-linux64 --headless --default-gc"}

# For debugging purposes
RUN=${RUN:-exec}

set -e

if [[ $# -eq 0 ]] ; then
    if [ -t 0 ] ; then
        # (B) start a shell
        $RUN bash
    else
        # (A) print help and exit
        $RUN $IMAGEJ --help
    fi
else
    COMMAND=$1
    if command -v "$COMMAND" >/dev/null 2>&1; then
        # (D) if the user has passed e.g. ImageJ-linux64,
        # then run it verbatim for backwards compatibility
        $RUN "$@"
    else
        # (C) Expected usage
        $RUN $IMAGEJ "$@"
    fi
fi

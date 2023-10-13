#!/bin/bash

function cleanup()
{
    local pids=`jobs -p`
    if [[ "$pids" != "" ]]; then
        kill $pids >/dev/null 2>/dev/null
    fi
}

if [ "$1" = "with-init" ]; then
    trap cleanup EXIT
fi

/test

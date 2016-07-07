#!/bin/bash

LOG_LEVEL="info debug_rpc warn test critical debug_sql error debug debug_rpc_answer notset"
CHECK_LOG_LEVEL=$2

logcheck() {
if [ ! -z $CHECK_LOG_LEVEL ]; then
    if [ "$(grep -o "$LOG_LEVEL")" == "$CHECK_LOG_LEVEL" ]; then
       echo "Starting the daemon with log_level"
    else
        echo "Check if the log-level argument name is correct!"
    exit 1
    fi
else
    echo "Starting the daemon"
fi
}

case "${1}" in
        start)
                logcheck
                ;;
        esac

exit 0
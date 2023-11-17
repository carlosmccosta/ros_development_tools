#!/usr/bin/env bash

sleep_sigterm="${2:-7}"
sleep_sigkill="${3:-6}"

#find_script_process_id_and_parent_group_id () { ps ax o pid,pgid,cmd | grep $1 | awk '!/grep|kill_script/'; }

find_script_parent_group_id () { ps ax o pid,pgid,cmd | grep $1 | awk '!/grep|kill_script/' | grep -v  grep | awk '{ print $2 }' | sort -n | uniq; }

kill_script ()
{
    if [ -n "$1" ]; then
        local sleep_before_sigterm="${2:-7}"
        local sleep_before_sigkill="${3:-6}"
        group_ids=$(find_script_parent_group_id $1)
        printf "\nGroup IDs found for script name [%s] -> [%s]\n" "$1" "$group_ids"
        if [ -n "$group_ids" ]; then
            for group_id in $group_ids; do
                printf "Sending SIGINT to processes with group ID [%s]\n" "$group_id"
                kill -INT -$group_id
            done
            if [ "$sleep_before_sigterm" -gt 0 ]; then
                printf "\n\nWaiting for %s seconds before escalating to SIGTERM...\n" "$sleep_before_sigterm"
                sleep $sleep_before_sigterm
                printf "Escalating to SIGTERM for shutting down unresponsive processes\n"
                for group_id in $group_ids; do
                    printf "Sending SIGTERM to processes with group ID [%s]\n" "$group_id"
                    kill -TERM -$group_id
                done
            fi
            if [ "$sleep_before_sigkill" -gt 0 ]; then
                printf "\n\nWaiting for %s seconds before escalating to SIGKILL...\n" "$sleep_before_sigkill"
                sleep $sleep_before_sigkill
                printf "Escalating to SIGKILL for shutting down unresponsive processes\n"
                for group_id in $group_ids; do
                    printf "Sending SIGKILL to processes with group ID [%s]\n" "$group_id"
                    kill -KILL -$group_id
                done
            fi
        fi
    else
        echo "Missing script name"
    fi
}

kill_script "$1" "$sleep_sigterm" "$sleep_sigkill"

exit 0

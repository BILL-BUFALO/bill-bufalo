#!/bin/sh

if ping -c 1 10.1.6.1 | grep -q "Destination"; then
    status_apache=""
else
    status_apache=""
fi

echo "$status_apache"

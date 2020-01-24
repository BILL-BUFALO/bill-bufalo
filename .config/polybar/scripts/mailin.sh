#!/bin/sh

mails=$(curl -u gb1.irk@gmail.com:wwlxsknetzxxmrotz --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | wc -l)

if [ "$mails" -eq "0" ]; then
echo " 0"
else
echo " $mails"
fi

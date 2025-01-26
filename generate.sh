#!/bin/bash
set -euo pipefail
falsepositives="google.com|yahoo.com|aol.com|opera.com|disqus.com|foxnews.com"
explicits="ads.google.com doubleclick.net"
# Downloading
wget -q https://wordpress.com/ads.txt -O wordpress.txt &
wget -q https://cnn.com/ads.txt -O cnn.txt &
wget -q https://foxnews.com/ads.txt -O foxnews.txt &
wget -q https://modrinth.com/ads.txt -O modrinth.txt &
wget -q https://aol.com/ads.txt -O aol.txt &
wget -q https://www.att.com/ads.txt -O att.txt &
wait
# Processing
base=$(cat *.txt |\
 cut -f1 -d, |\
 grep -v \# |\
 grep -v subdomain= |\
 tr [:upper:] [:lower:] |\
 grep -Ev $falsepositives |\
 sort |\
 uniq |\
 xargs)
# Outputting 
for domain in $base $explicits; do
 echo $domain
 echo \*.${domain}
done

ssh nuc hostname; ip -h -c -f inet address | grep global; \
uptime  | awk -F, '{print $1,$2}'     | sed 's/:/h /g;s/^.*up *//; s/ *[0-9]* user.*//;s/[0-9]$/&m/;s/ day. */d /g' | \
awk '{print "Uptime:",$1,$2,$3, $4}'
df -h /
nmap -n nuc elite
ping -c 5 -M dont yuotube.com
speedtest

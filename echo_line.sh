#!/bin/sh
f=$1;t=$(expr $1 + 5)p;
sed -n "$f,$t" $2
#Install in ~/.bashrc -> alias echo_line="~/dev/wb-shell-scripts/echo_line.sh"
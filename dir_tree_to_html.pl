#!/bin/bash
#Perl one liner code from: https://geekalicious.academy/2022/01/10/perl-one-liner-directory-tree-maker/
(DIRMAP="directory-map-$(date +%s).html" && \
perl -i -spe 's`(?:<a (class="DIR"))[^>]+>([^<]+)</a>`<span $1>$2</span>`g; $edit = 0 if m`</body>`; $edit = 1 if m~<hr>~; s`.*`` if $edit; BEGIN { print qq~[J\033[H\033[J~ }' \
-- -cmd="$(tree --dirsfirst -CT 'Directory Map' -H './' -o $DIRMAP)" -- $(echo $DIRMAP))

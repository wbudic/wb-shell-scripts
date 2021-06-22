#!/bin/perl 
use strict;
use warnings;
use POSIX 'isatty';  
#Intersect piped input with vim for editing and further output.
if (isatty(*STDIN)){
    print "No STDIN piped in, enter it then manually, end feed with ctrl+d!\n"
}
system ('vim - -c "w!.__tmp__vimpiped.txt" 2>&1');
my $THD;
open($THD, "<", ".__tmp__vimpiped.txt") or exit 0;
while(<$THD>){print STDOUT $_}
close $THD;
system('rm .__tmp__vimpiped.txt');
exit 1;

#!/bin/perl 
use strict;
use warnings;
use POSIX 'isatty';  
#Intersect piped input with vim for editing and further output.
if (isatty(*STDIN)){
    print "No STDIN piped in, enter it then manually, end feed with ctrl+d!\n"
}
my $tmp = '.__tmp__vimpiped.txt';
my $lmd = `cat > $tmp; stat --printf='%z' $tmp`; 
system("vim -n $tmp < /dev/tty > /dev/tty");

#We simply quit, on modifications. So nothing gets further piped out.
if($lmd ne `stat --printf='%z' $tmp`){
    my $THD;
    open($THD, "<", $tmp) or exit 0;
    while(<$THD>){print STDOUT $_}
    close $THD;
}
system("rm $tmp");
exit 1;
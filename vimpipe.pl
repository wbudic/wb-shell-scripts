#!/bin/perl 
use strict;
use warnings;
use POSIX 'isatty';  
#Intersect piped input with vim for editing and further output.
if (isatty(*STDIN)){
    print "No STDIN piped in, enter it then manually, end feed with ctrl+d!\n"
}
my $stm = `date +\%s`; $stm =~ s/\n$//;
my $tmp = ".__tmp__vimpiped_$stm.tmp";
my $lmd = `cat > $tmp; stat --printf='%z' $tmp`; 
####################################################################

system("vim -n $tmp < /dev/tty > /dev/tty");

####################################################################
# ~ Notice !
# If it was a quit in vim, there is no modifications of the STDIN. 
# i.e. an :wq was not issued. We then don't pipe nothing further out.
#
if($lmd ne `stat --printf='%z' $tmp`){
    my $THD;
    open($THD, "<", $tmp) or exit 0;
    while(<$THD>){print STDOUT $_}
    close $THD;
    
}
system("rm $tmp");    
exit 1;
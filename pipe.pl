#!/bin/perl 
use 5.10.0;
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;
use Term::Form;

my ($pid, $ret, $parent);
state @buffer = ();
use POSIX 'isatty';  

print "stdin_isatty:".isatty(*STDIN)."\n";
if (!isatty(*STDIN)){	
	while(my $ln = <>){		
		chomp($ln);		
		push @buffer, $ln;		
	}
	
}

if(!defined($pid = fork())) {
   # fork returned undef, so unsuccessful
   die "Cannot fork a child: $!";
} elsif ($pid == 0) {
   print "Printed by child process isatty:".isatty(*STDIN)."\n";
    my $ln = <>;
	print"[$ln]\n";		
   exec("date") || die "can't exec date: $!";     
} else {
   # fork returned 0 nor undef
   # so this branch is parent
   print "Printed by parent process\n";
   $ret = waitpid($pid, 0);
   print "Completed process id: $ret\n";  
}

sub addDone{
	my $pid = shift;
	print "Process $pid called\n"
}
my $THD;
open($THD, "+<", "/dev/tty") or die "no tty: $!";
while(my $ln = <$THD>){
	chomp($ln);	
 last if $ln eq ".";
}
close $THD;


print '-' x 80 . "\n";
print join ("\n",@buffer)."\n";
print '-' x 80 . "\n";

1;
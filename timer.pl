#!/bin/perl 
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;

my $t = Term::Screen->new(); $t->noecho(); $t->at($t->rows()-2,0); 
my $exited = 0;
$SIG{'INT'} = sub {
	print RESET "\nCTRL+C <- Terminated!\r\n";  
	$t->echo(); 
	$t->curvis(); 
	$exited=1; 
};

my $cnt_down = 15*60; # in secs, default is 15 min.
my $beg = time;
my $end = $beg + $cnt_down;
my ($msg, $time, $cur, $cmd); 

$| = 1;
 
foreach my $arg(@ARGV){
  if ($arg =~ /\d+/){
      $end = $beg + $arg * 60;
  }else{
      $cmd = $arg; print "cmd -> $cmd\n";
  }
}
for (;;) {
   $time = time;
   last if ($time >= $end);
   $cur = $end - $time; 
   $msg = printf("%02d:%02d:%02d", $cur/(60*60), $cur/(60)%60, $cur%60); $msg=~s/^\d//;
   if (($cur/(60)%60)>1){
      print  RESET, YELLOW, "\rTimer-> ", BOLD, CYAN, $msg 
   }else{
      print  RESET, "\rTimer-> ", BOLD, RED, $msg 
   }
   sleep(1);
   $t->flush_input();
   $t->clreol();
   exit if $exited;
}
$msg = "\rTimer has expired!\r\n";
print RESET $msg;
$t->echo(); $t->curvis();

`/usr/bin/notify-send "TIMEOUT" "$msg"&`;
if($cmd){
 system($cmd);
}else{
`mpv --no-video "$ENV{HOME}/Fiona Apple - Fast As You Can-NbxqtbqyoRk.mkv"`;
}


1;

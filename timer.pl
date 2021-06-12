#!/bin/perl 
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;
use Term::Menus;

my $cnt_down = 15*60; # in secs, default is 15 min.
my $beg = time;
my $end = $beg + $cnt_down;
my ($msg, $time, $cur, $cmd); 

 if(scalar @ARGV>0){
   foreach my $arg(@ARGV){
      if ($arg =~ /\d+/){
            $end = $beg + $arg * 60; print "Minutes -> $arg\n";
      }else{
            $cmd = $arg; print "Command -> $cmd\n";
      }
   }
   print "Activating...\n";
 }else{
    my @lst = (5,15,20,30,40,45,50,60);
    my $sel=&pick(\@lst,"Which is your desired timeout in minutes (from 1..8)?");
		if($sel ne "]quit["){
         print "Setting timer to $sel minutes.\n"; 
         sleep(1);
         $beg = time;
	      $end = $beg + $sel * 60;

		}else{
			 exit; 
		}
 }


my $t = Term::Screen->new();
my $exited = 0;
$SIG{'INT'} = sub {
	print RESET "\n[CTRL]+[C] <- Terminated!\r\n";  
	$t->echo(); 
	$t->curvis(); 
	$exited=1; 
};
$| = 1;
$t->noecho(); $t->at($t->rows()-2,0); 
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
   exit 0 if $exited;
}
$msg = "\rTimer has expired!\r\n";
print RESET $msg;
$t->echo(); $t->curvis(); undef $t;

`/usr/bin/notify-send "TIMEOUT" "$msg"&`;
if($cmd){
 system($cmd);
}else{
 system('mpv --no-video "$ENV{HOME}/Fiona Apple - Fast As You Can-NbxqtbqyoRk.mkv"');
}


1;
#!/bin/perl 
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;


my $sta = time;
my $end = $sta + 15*60;
my ($msg, $time, $cur, $cmd); 

 if(scalar @ARGV>0){
   foreach my $arg(@ARGV){
      if ($arg =~ /\d+/){
            $end = $sta + $arg * 60; print "Minutes -> $arg\n";
      }else{

            if($arg =~ m/^-+.*/){
               while(<DATA>){print $_}
               exit;
            }
            else{
               $cmd = $arg; print "Command -> $cmd\n";
            }
      }
   }
   print "Activating...\n";
 }else{
    my $lst = 'Cancel\n 3m\n 5m\n 10m\n 15m\n 20m\n 25m\n 30m\n 40m\n 45m\n 50m\n 60m\n 90m\n 1h\n 2h\n 3h\n 4h\n 3s\n 10s\n 30s';
    my $cmd = qq(
       echo '$lst'|fzf --no-multi --cycle --height=12 --border --margin 1,1% --pointer='->' --color=dark --print-query
                          --info=inline --header='<- Please select your desired timeout. Check out your, ^ arrow, PgUp, PgDwn, and ESC key.'
    ); $cmd =~ s/[\n\r\t]//g; 
    my $sel=`$cmd`;$sel =~ s/\s//g; 
		if($sel ne "Cancel"){
         $sta = time;
         if($sel =~ m/m$/){
            $sel =~ s/m$//;
            print "Setting timer to [$sel] minutes.\n";
            $end = $sta + $sel * 60;
         }
         elsif($sel =~ m/h$/){
            print "Setting timer to $sel.\n";
            $sel =~ s/h$//;
            $sel *= 60;
            $end = $sta + $sel * 60;
         }elsif($sel =~ m/s$/){
            $sel =~ s/s$//;
            $end = $sta + $sel;

         }else{
            exit 1;#<- should not be possible!
         }
         sleep(1);   
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
$t->noecho(); 
$t->at($t->rows()-2,0); 

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
 system(qq(mpv --no-video '$ENV{HOME}/Fiona Apple - Fast As You Can-NbxqtbqyoRk.mkv'));
}
__END__
COUNTDOWN TIMER
  by Will Budic (https://github.com/wbudic/wb-shell-scripts)

Syntax:

$ ./timer.pl {minutes} {shell_cmd}

Without any arguments, uses the fzf utility to propmt for period.
Defaults to 15 minutes, if only shell command is given.
Modify last line in script to include own alarm/music to play as default on timer expiry.
System bells are unacceptable.

Requirements:
sudo apt install mvp
fzf (don't use apt to install, can be crap, install manually for vim and from your home)

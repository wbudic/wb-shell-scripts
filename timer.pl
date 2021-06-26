#!/bin/perl 
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;


my $sta = time;
my $end = $sta + 15*60;
my ($time, $cur, $sur, $cmd); 

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
   print "Activated timer($$)...\n";
 }else{
    my $lst = 'Cancel\n 3m\n 5m\n 10m\n 15m\n 20m\n 25m\n 30m\n 40m\n 45m\n 50m\n 60m\n 90m\n 1h\n 2h\n 3h\n 4h\n 3s\n 10s\n 30s';
    my $cmd = qq(
       echo '$lst'|~/.fzf/bin/fzf --no-multi --cycle --height=12 --border --margin 1,1% --pointer='->' --color=dark --print-query
                          --info=inline --header='<- Please select your desired timeout. Check out your, ^ arrow, PgUp, PgDwn, and ESC key.'
    ); $cmd =~ s/[\n\r\t]//g; 
    my $sel=`$cmd`;$sel =~ s/\s//g; 
		if($sel ne "Cancel"){
         $sta = time;
         if($sel =~ m/m$/){
            $sel =~ s/m$//;
            print "Setting timer($$) to $sel minutes.\n";
            $end = $sta + $sel * 60;
         }
         elsif($sel =~ m/h$/){
            print "Setting timer($$) to $sel in hours.\n";
            $sel =~ s/h$//;
            $sel *= 60;
            $end = $sta + $sel * 60;
         }elsif($sel =~ m/s$/){
            print "Setting timer($$) to $sel in seconds.\n";
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
$t->at($t->rows()-1,0); 

my $stopwatch = time; my ($tt, $stoptime, $tc) = 0; my $stop =0;
while() {
   $time = time;
   last if ($time > $end);
   $cur = $end - $time; 
   $sur = $time - $stopwatch if ! $stop;
   $t->flush_input();
   $t->clreol(); $t->curinvis();  
   my $stmp1 = sprintf("%02d:%02d:%02d", $cur/(60*60), $cur/(60)%60, $cur%60); $stmp1=~s/^\d//;
   my $stmp2 = sprintf(" [%02d:%02d:%02d]", $sur/(60*60), $sur/(60)%60, $sur%60); $stmp2=~s/^\d//;
   $t->at($t->rows()-1, 5);
   if (($cur/(60)%60)>1){
      print  YELLOW "\rTimer-> ", RESET, BOLD, CYAN, $stmp1, RESET, GREEN $stmp2, RESET;
   }else{
      $tc=0 if $tc++>3;      
      if (($cur%60)<2){
         print  BOLD, GREEN, "\rTIMER ",  "---> ", $stmp1, RESET, GREEN, $stmp2, RESET;
      }else{
         print  RED "\rTimer ", BOLD;
         if($tc==0){print YELLOW, "-", RED, "--"}
         elsif($tc==1){print "-", YELLOW, "-", RED, "-"; print chr(7)}
         elsif($tc==2){print "--", YELLOW, "-"}
         else{print "---", YELLOW}
         print "> ", RED,  $stmp1, RESET, GREEN, $stmp2, RESET;
      }      
   }   
   if(!$exited){   
         if($t->key_pressed(1)){
            $stop = $stop?0:1;
            print RED " Stopwatch -> ".($stop?"Paused":"Runing")."!";
            if($stop){$stoptime = $stopwatch = $sur}else{$stopwatch = time -$stoptime}
            
         }elsif(int(rand(10)) > 4){
            $time = `date '+%r'`; $time =~ s/\n$//;
            print MAGENTA " Local Time: $time";
         }
   }else{
      exit 0;
   }
}
my $msg = "\r\nTimer has expired!\r\n";
print RESET $msg;
$t->echo(); $t->curvis(); undef $t;

`/usr/bin/notify-send "TIMER ($$)" "$msg"&`;
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
fzf (don't use apt to install, can be crap old version,
    install manually for vim and from your home, and symbolik link)
i.e. ln -s ~/.fzf/bin/fzf ~/.local/bin/fzf 

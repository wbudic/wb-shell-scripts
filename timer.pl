#!/usr/bin/env perl
use strict;
use warnings;
use Term::ANSIColor 2.01 qw(:constants colored);
use Term::Screen;

my ($sta,$end) = (time,undef);#my $end = $sta + 15*60;
my ($time, $cmd); 

our @pos = getCPos();
our $exited = 0; my $row = $pos[0]; my ($title,$tlo);
our $t = Term::Screen->new();
local $SIG{'INT'} = *interupt;
$t->at($row,0)->clreol();

if( scalar @ARGV > 0 ){
    printf "\rActivated count down timer($$)...(Use CTRL+C to terminate!)\n";$row+=2;
	foreach my $arg(@ARGV){
        if ($tlo) {
            undef $tlo; $title=$arg;
            $row++;
            print BOLD "\rTimer:", BRIGHT_BLUE, ON_BRIGHT_BLACK," $title \n", RESET
        }
        elsif ( $arg =~ /^\d+/ ) {
            $end = $sta + $arg * 60;
            print "\rCountdown set to minutes: $arg\n";
        }
        elsif ( $arg =~ /^-+t.*/ ) {
            $tlo = 1;
        }
		  elsif ( $arg =~ /^-+f.*/ ) {
            &fzf;
        }
        elsif ( $arg =~ /^-+[^0-9]+/ ) {
			$t->at($row-3,0)->clreol();undef $t; 
            while (<DATA>) {print transPrint($_)}
            exit;
        }
        else {
            $cmd = $arg;
            print "\rCommand to run after -> $cmd\n";
            $row++;
        }
	}
}

# Hey, let's do some Perl Language only available ANSI magic.
my $cur_col;
sub transPrint { my $ln = shift;
	if($ln =~ /<\/*.*>/){
	   ($ln=~/(.*)<(.*)>(.*)<\/*(.*)>(.*)/);	   
	   if($2){
	   		print $1, colored([$2], $3), $5, "\n" if length($2)>1;
			undef $cur_col;
	   }else {		   
		   ($ln=~/<\/*(.*)>(.*)|(.*)<\/*(.*)>/);
		   if($4){
			print colored([$cur_col], $3), "\n";
			undef $cur_col;
		   }else{
		    $cur_col=$1;
		   	print colored([$cur_col], $2), "\n"
		   }
	   }
	}	
	elsif($cur_col){print colored([$cur_col], $ln)}
	else{print $ln;}	
return
}

&fzf unless $end;

my $stopwatch = time;
my ($tt, $ptime, $stoptime, $tc,$cur,$sur) = 0;
my ($stop,$stop_countdown) = (0,0);
$t->at($row, 0)->curinvis(); die "Time not specified!" unless $end;

while() {
	$time = time;
	last if ($time > $end);

	$cur = $end - $time unless $stop_countdown;
	$sur = $time - $stopwatch unless $stop;
	$t->flush_input();
	$t->clreol();
	my $stmp1 = sprintf("%02d:%02d:%02d", $cur/(60*60), $cur/(60)%60, $cur%60);
	$stmp1=~s/^\d//;
	my $stmp2 = sprintf(" [%02d:%02d:%02d]", $sur/(60*60), $sur/(60)%60, $sur%60);
	$stmp2=~s/^\d//;	

	if (($cur/(60)%60)>1){
		print  YELLOW "\rTimer-> ", ON_BRIGHT_BLACK, BOLD, CYAN, "  $stmp1  ", RESET, GREEN, $stmp2, RESET unless $stop_countdown;
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
	
	if($exited){exit 1}
	if($t->key_pressed(1)){		
		my $ch = $t->getch(); $t->at($row,30);
		if($ch eq 'p'){
			$stop_countdown =$stop_countdown?0:1; $stop=0;
			print RED, BLINK, " Countdown -> ".($stop_countdown?"Paused":"Running")."!", RESET;
			if($stop_countdown){$stoptime = time}
			else{$end += time - $stoptime;}
		}else{
			$stop = $stop?0:1;
			print RED " Stopwatch -> ".($stop?"Paused":"Running")."!";
			if($stop){$stoptime = $stopwatch = $sur}
			else{$stopwatch = time -$stoptime}
		}		
	}else{
		$ptime = `date '+%r'`;
		$ptime =~ s/\n$//;
		print MAGENTA,  " Local Time: $ptime", RESET unless $stop_countdown |$stop;
	}
}

$t->curvis()->normal()->clreol();$title=$$ unless $title; 
my $msg = "Timer '$title' has expired!";

`/usr/bin/notify-send "TIMER $title" "$msg"&`;

$ptime = `date '+%r'`; $ptime =~ s/\n$//;
print BRIGHT_RED, BLINK, "\r$msg  [ $ptime ]\n", RESET;

if($cmd){
	$t->echo();
	system('echo "\e[?25h"'); 
	print YELLOW "\rResult of ->`".$cmd, "` is:\r\n";
    my @res = qx/$cmd/; 
	foreach my $l(@res){
		$l =~ s/\n*$//;
		print RESET $l, "\r\n";
	}
}else{	   #MODIFY BELLOW TO DESIRED ALARM, or move the provided ./chiming-and-alarm-beeps.wav to your Music folder.
	system("mpv --vid=no --loop-file=3 $ENV{HOME}/Music/chiming-and-alarm-beeps.wav > /dev/null");
	$row-=5 if $row>$t->rows();
	$t->at($row+1, 0)->clreol()->at($row, 0); print BRIGHT_RED, "\r$msg  [ $ptime ]", RESET;
	system('echo "\e[?25h"'); 
	$t->dl()->at($row+1, 0)->clreol()->echo()->curvis();
}
exit 1;

sub fzf {

my $lst = 'Cancel\n 3m\n 5m\n 10m\n 15m\n 20m\n 25m\n 30m\n 40m\n 45m\n 50m\n 60m\n 90m\n 1h\n 2h\n 3h\n 4h\n 3s\n 10s\n 30s';
my $cmd = qq(
	echo '$lst'|~/.fzf/bin/fzf 
					--no-multi --cycle --height=12 --border --margin 1,1% --pointer='->' --color=dark --print-query
					 --info=inline --header='<- Please select your desired timeout. Check out your, ^ arrow, PgUp, PgDwn, and ESC key.'
);
	$cmd =~ s/[\n\r\t]//g;
	my $sel=`$cmd`;
	$sel =~ s/\s//g;
	if($sel ne "Cancel"){
		$sta = time;
		if($sel =~ m/m$/){
			$sel =~ s/m$//;
			print "Setting timer($$) to $sel minutes.\n";
			$end = $sta + $sel * 60;
		}
		elsif($sel =~ m/h$/){
			$sel =~ s/h$//;
			print "Setting timer($$) to $sel in hours.\n";			
			$sel *= 60;
			$end = $sta + $sel * 60;
		}elsif($sel =~ m/s$/){
			$sel =~ s/s$//;
			print "Setting timer($$) to $sel in seconds.\n";			
			$end = $sta + $sel;
		}
		else{
			exit 1;#<- should not be possible!
		}		
	}else{
		exit;
	}
	return $t->at($row-=5, 0)
}
sub interupt {
	$exited=1;	
	system('echo "\e[?25h"');#sleep 1;
	$row+=1;	
	$t->at($row, 0)->clreos()->echo()->curvis();	
	print RESET, "[CTRL]+[C] <- Terminated!\r\n";
	exit 0;
};


#Following fckn sub took me two days to figure out.
sub getCPos {
my $x=q!
exec < /dev/tty
oldstty=$(stty -g)
stty raw -echo min 0
printf "\033[6n" > /dev/tty
sleep 0.5  
IFS=';' read -r row col
stty $oldstty
row=$(expr $(expr substr $row 3 99) - 1)        # Strip leading escape off
col=$(expr ${col%R} - 1)                        # Strip trailing 'R' off
echo $col,$row
!;
$x=qx($x);
return reverse split ',', $x;
}
__END__

<bold>THE BEST COUNTDOWN TIMER</bold>
  by Will Budic (https://github.com/wbudic/wb-shell-scripts)

<green bold>Syntax</green on_black>:

$ <bold>./timer.pl</bold> {minutes} {shell_cmd} {-t 'Title of instance'} 

<yellow>Without any arguments, it uses the fzf utility to prompt for minute period.
Modify line containing mpv path in script to include own alarm/music to play as default on timer expiry.
Scroll above this script to line: 146
System bells are unacceptable.</yellow>

Also, you can now pause, for what ever reason the countdown, by pressing 'p'.

<green bold>Requirements</green>:
fzf (don't use apt to install, can be crap old version,
    install manually for vim and from your home, and symbolik link)
i.e. ln -s ~/.fzf/bin/fzf ~/.local/bin/fzf 
sudo apt install mvp
Install in .bashrc alias to path (mine is):
alias timer="~/timer.pl"
Install chime or alarm to play:
cp ./chiming-and-alarm-beeps.wav ~/Music/chiming-and-alarm-beeps.wav
---

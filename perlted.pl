#!/bin/perl 
use strict;
use warnings;
use Term::ANSIColor qw(:constants);
use Term::Screen;
use Term::Form;


my $t = Term::Screen->new();
my $exited = 0;
$SIG{'INT'} = sub {
	print RESET "\n[CTRL]+[C] <- Terminated!\r\n";  
	$t->echo(); 
	$t->curvis(); 
	$exited=1; 
};
$| = 1;
my $pos = $t->rows() - 2;
$t->at($pos,0); 
my $enters = 0;
my %opts = (info=>"You are in a perlted line edit buffer (.q(uit)):", clear_screen=>0, color=>1, no_echo=>0, hide_cursor=>0);
my $new = Term::Form->new(); 
my $ln; 
my @buffer=(); my %scratch=();
my $prompt= ': '; my ($epos,$npos);
sub list {
	   my $len = scalar @buffer;
	   for (my $i=$len; $i > 0;$i--) {
		   $t->at($pos-1-$i, 0);
		   $t->clreol();
		   my $idx = $len - $i;
		   if ($idx > -1){
			   print 1 + $idx.": ".$buffer[$idx]
		   }else{
			   print "\n"
		   }
	   }
}
do{
   $ln = $new->readline( $prompt, \%opts );   
   if($ln eq ".cls"){
	   $t->clrscr();
	   &list;
	   $t->at($pos-1, 0);
   }
   elsif($ln =~ /^.ls*/){
	   &list;
	   $t->at($pos-1, 0);
   }
   elsif($ln =~ m/^\.\d+[e|n]$/){
	   $npos = 1 if $ln =~ m/n$/;
	   $ln =~ /(\d+)/;
	   my $i = $1;  $prompt = "$i:"; $epos = $i-1;
	   $opts{'default'} = $buffer[$epos];	   
   }   
   elsif($prompt ne ': '){
	     $buffer[$epos] = $ln; 
		 if($npos && $epos < $enters){
			$prompt = "$epos:"; 
			$epos++; 
			$opts{'default'} = $buffer[$epos];
		 }
		 else{
		 	$prompt = ': '; $opts{'default'} ="";
		 }
		 &list;	   
	     $t->at($pos-1, 0);
   }
   elsif($ln =~ m/^\.\d*.*\dd$/){	   
	   $ln =~ /^\.(\d+)|([\.\,]*\s*)(\d+)d$/;	   
	   my $i = $1;  $prompt = "$i:"; $epos = 0;
	   $scratch{".$i"} = $buffer[--$i];
	   $opts{'default'} =""; $prompt = ': ';
	   $opts{'info'} ="Scratch bufferd line .".$i."d contents.";	   
	   $enters=@buffer-1;	   
	   for(my $j=$enters+1;$j>$i;$j--){
		   $t->at($pos-1-$j, 0); $t->clreol();
	   }

	   
	   my @s = splice @buffer, 0, $i;
	   if($i!=$enters){
	   	  my @r = splice @buffer, $i, $enters;	   
	   	  push(@s, @r); 
	   }
	   @buffer  = @s;
	   &list;
	   $t->at($pos-1, 0);
   }
   elsif($ln eq '.d'){
	   $enters=@buffer-1;
	   $t->at($pos-$enters-2, 0);  $t->clreol();
	   $scratch{".d"} = pop @buffer;
	   &list;
	   $t->at($pos-1, 0);
   }
   elsif($ln ne ".q"){
	   push (@buffer, $ln);	   
	   &list;
	   $t->at($pos-1, 0);	   
   }
}while($ln ne '.q');
$t->echo(); $t->curvis(); undef $t;

print '-' x 80 . "\n";
print join ("\n", @buffer) ."\n";
print '-' x 80 . "\n";


1;
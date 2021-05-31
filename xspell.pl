#!/bin/perl
# XSPELL program by Will Budic.
#Requirments:
#sudo cpan install Clipboard
#sudo cpan install Term:Menus
use Clipboard;
use Term::Menus;
my ($w,$spell)=@ARGV;
if (!$w){
 print "\e[31m\e[1mError ->\e[0m You didn't include which word to xspell.\nEnter -h for help.\n"; 
 exit 0;
}elsif($w=~/^-/){
print qq/
\e[96m\e[1mXSPELL v.2.0\e[0m\e[94m

Spellcheck and copy to system clipboard some complicated word.
---------------------------------------------------------------------\e[0m
This program uses aspel to spell check a provided word.
If the word is correct, it will also provide you its dictionary
definintion before exiting.
Examples:

\e[94m$0 \e[92m{word}\e[0m	
Will spell check and copy only the word,

and if correct will display definition.
If incorrect will provide you with alternatives.

\e[94m$0 \e[92mspell {word}\e[0m
Will spell check and correct the word for you.
Try:
>\$ $0 gnnarly
---------------------------------------------------------------------\e[0m
/;
exit 0;
}
$w=$spell if $spell;
my $list = `echo \"$w\" | aspell -a`;
my $banner =qq(
The following list of alternatives for [$w], 
will been copied to clipboard however, 
maybe you want to select the right word from bellow.
To cancel press [ctrl-c], and nothing will be copied:
);
if($list=~/\*$/gm) {	
	copy($w);
	exec("curl dict://dict.org:/d:\"$w\":* | less");	
}
else{
	$list=~s/^(.*\s+)*0:\s*//; $list=~s/\s*$//;
	my @lst = split(', ',$list);
	if($spell){
		copy($lst[0]);
	}else{
		my $sel=&pick(\@lst,$banner);
		if($sel ne "]quit["){
			 copy($sel) 
		}else{
			 copy($list) 
		}
	}
}

sub copy{
	$w = shift;
	Clipboard->copy_to_all_selections($w);
	print "Copied to clipboard -> [$w]\n";
}
1;

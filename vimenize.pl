#!/usr/bin/perl -w
#
# vim tab open fuzzy find selected list of files.
# by default filters for *.sh, *.txt, *.pl.
#
# Programed by: Will Budic
# Open Source License -> https://choosealicense.com/licenses/isc/
#
use v5.10;
use strict;
use warnings;

use IPC::Run qw( run );

my @VIM = ("vim");
my $tabs = 1;
my @vim_args = ();
my @ext_args = ();#-path '/home/will/.' -or -path '/home/will/.cpan*'
my $EXLS = "-path '$ENV{'HOME'}/.' -o -path '$ENV{'HOME'}/.cpan'";
my $EXTS = '-name "*.sh" -o -iname "*.txt" -o -iname "*.pl" -o -iname "*.cgi" ! -name ".*"';
my $help = qq(
This is an utility to find and filter with preview to vim text files.
By default it filter includes for *.sh, *.txt, *.pl type of file extensions.
For convinence sake, by default files are opened in vim in tabs.

Use the {_} option, to instruct to load into buffers, instead.
Use the {^}{ext} option, to instruct to prefix find files.

Syntax: $0 {_} {-vim_option}... {ext_name}...
Examples:
To find and open in tabs read only mode text files:
    $0 -p -R txt

To find and open selected files in buffers, of type *.c or *.cpp:
    $0 _ c cpp
);

if (@ARGV>0) {    
    foreach my $arg(@ARGV){
       #print "{{{$arg}}}"; 
       if($arg =~ /^\-/){
           if($arg=~/(^\-*\?)/){
              print $help;
              exit;  
           }
           push @vim_args, $arg;
       }elsif($arg =~ /^_/){
            $tabs = 0;
       }elsif($arg ne $ENV{'HOME'}){           
           if($arg=~/^\w+\./){
              print "Ignoring -> $arg\n"; 
              next;
           }elsif($arg=~/^\^\w+/){
               print "Translating -> $arg\n"; 
               my $trans = substr $arg,1;
               push @ext_args, "-iname \"$trans*\" -o"; 

           }else{
               if($arg=~/^\*/){
                   print "\nWARNING! Not valid syntax -> $arg ";
                   push @ext_args, "-iname \"$arg\" -o";
               }
               else{
                push @ext_args, "-iname \"*.$arg\" -o";
               }
           }
       }
    }
    
}
push @vim_args, "-p" if $tabs;
push @VIM, @vim_args;
print join (' ', @VIM), " <- ";

if (@ext_args > 0){
    $EXTS = join (' ', @ext_args);
    $EXTS =~ s/ \-o$/ /;
}
print "find -H $ENV{'HOME'} \\( $EXLS \\)\n-prune -o \n-type f \\( $EXTS \\)\n| fzf -m", "\n\n";
my $lst = qx(find -H $ENV{'HOME'} \\( $EXLS \\) -prune -o -type f \\( $EXTS \\)|fzf -m --tac --preview 'cat {}');#--preview-window down);
my @lst = split(/\s/, $lst);
if(@lst>0){    
    push @VIM, @lst;
    print join (' ', @VIM), "\n";
    run \@VIM;
}else{
    print "You have chickened out to vim.\n"
}



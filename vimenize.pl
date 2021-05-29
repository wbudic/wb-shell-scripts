#!/usr/bin/perl -w
#
# vim open fuzzy find selected list of files, with many options.
# by default filters for *.sh, *.txt, *.pl.
#
# Programed by: Will Budic
# Open Source License -> https://choosealicense.com/licenses/isc/
#
use v5.10;
use strict;
use warnings;

use IPC::Run qw( run );

my $TITLE = "FILE SELECTOR FOR VIM v.2.0";

my (@VIM, @vim_arguments, @ext_arguments , @prn_arguments)  = (("vim"), (),(),());
my $HOME  = $ENV{'HOME'};
my $PRNS  = "-path '$HOME/.' -o -path '$HOME/.cpan'";
my $EXTS  = '-iname "*.sh" -o -iname "*.txt" -o -iname "*.pl" -o -iname "*.cgi" ! -name ".*"';
my $NOTS  = '-path "*/go/*" -o -path "*/goroot/*" -o -path "*/.cache/*" -o -path "*/Steam/*" -o -path "*/.vscode/*"';
my $help  = qq(
$TITLE

Syntax: $0 {_} {-vim_option}... \${ext_name}... !{path}... +{path}...

This utility helps to preselect, filter and find files to open with the vim text editor.
To select a desired and searched file to be opened, use the [TAB] key. 
By default this program will filter for *.sh, *.txt, *.pl and *.py type of file extensions in your home directory.
See bellow further available argument options, to go beyond the basics and extend your search selection.

Argument Options:

Use the {_} option, is to instruct to open in vim into open_in_vim_tabs selected files or file.

Use {!}{path}, to exclude whole folder paths from to be displayed.
    i.e. !Videos !Music/lyrics - Will not search for files and folders to display in the ~/Videos and ~/Music/lyrics folders.

The {+}{path} option will search further addional folder paths for you. These have to be valid and accessible.

The {^}{ext} option is instruction which extension(s) to search for, and not use the defaults. 
    i.e ^.txt - Will search only by extension name for text files.
    i.e ^.c ^cpp - Will search only for c and cpp source files.

Examples:

To find to select and open in open_in_vim_tabs with read only mode text files:
    $0 _ -R txt

To find and open selected files in buffers, by extension type of *.sh and *.pl:
    $0 _ c sh pl
);
my $PATHS = $HOME; processArguments(); ##-a !-type -d
my $cmd = qq(find -H $PATHS \\( $PRNS \\) -a -type d -prune -o -type f \\( $EXTS \\) 
                  -a ! \\( $NOTS \\)
             | fzf -m --tac --preview 'batcat --color=always {}'
          );$cmd =~ s/\s+/ /g;
my $lst = qx($cmd);
my @lst = split(/\n/, $lst);
print "\nFile selector -> [$cmd]\n";
print "VIM arguments -> ".join (' ', @VIM)."\n";
if(@lst>0){
    foreach(@lst){
	    push @VIM, $_;
    }     
    print join (' ', @VIM), "\n";
    ###
        run \@VIM;
    ###
}else{
    print "$0 has been abruptly terminated.\n"     
}

sub processArguments {
    my ($open_in_vim_tabs, $translate, $explicit) = (0, "", 0);
    if (@ARGV>0) {  
            foreach my $argument(@ARGV){
                #print "{{{$argument}}}"; 
                if($argument =~ '~'){
                    die '~'
                }
                if($argument =~ /^\-/){
                    if($argument=~/(^\-*\?)/){
                        print $help;
                        exit;  
                    }
                    push @vim_arguments, $argument;
                }elsif($argument =~ /^_/){
                        $open_in_vim_tabs = 1;
                }elsif($argument ne $ENV{'HOME'}){           
                    if($argument=~/^\^\w+/ ){
                        print "\nTranslating ext -> $argument\n";
                        $translate = substr $argument,1; $translate = $translate = substr $argument, 2 if $translate =~ /^\*/;
                        push @ext_arguments, "-iname *.\"$translate\" -o";
                    }elsif($argument=~/^E\:\w+/ ){
                        print "\nTranslating ext -> $argument\n"; 
                        $translate = substr $argument, 2; $translate = $translate = substr $argument, 2 if $translate =~ /^\*/;
                        push @ext_arguments, "-iname *.\"$translate\" -o";
                    }
                    elsif($argument=~/^P\:(\/)*\w+/){                        
                        $translate = substr $argument, 2;
                        $translate =~ s/\/$//;
                        print "\nTranslated folder path to prune '$argument' to -> $translate";                        
                        if(not -e $translate){
                            print "\nWARNING! The translated prune path for '$argument' as folder doesn't exsist -> $translate, prepending slash to autofix.\n";
                            $translate = '/'.$translate; $translate =~ s/\/\//\//;
                            if(not -e $translate || not -d $translate){
                                      $translate = "$HOME/$translate";
                                      print "\nWARNING! The translated path for '$argument' resolved to -> $translate.";
                            }
                            die "\nERROR Resolved -> $translate is not a valid path!\n" if(not -d $translate);
                        }
                        if(not -d $translate){

                        }
                        push @prn_arguments, "-path \"$translate\" -o";
                    }
                    elsif($argument=~/^A\:(\/\/)*\w+/i){  die "Error, not a full path '$argument', we are very, very, sorry." if $argument !~/^A\:\/\w+/;
                        print "\nTranslating additional folder path to search -> $argument\n";
                        $translate = substr $argument, 2;   
                        if(not -e $translate){
                            die "\nERROR!$!\nThe translated path for '$argument' as folder doesn't exsist -> $translate."
                        }
                        else{
                              $PATHS .= ' '.$translate;
                        }
                    }
                    elsif($argument=~/^\w+\./){
                        print "\nIgnoring -> $argument\n"; 
                        next;
                    }
                    elsif($argument=~/^\*/){
                            print "\nWARNING! Not a valid syntax -> $argument, if it is an extension, you do not need a wildcard prefix.";
                            push @ext_arguments, "-iname \"$argument\" -o";
                    }
                    elsif($argument=~/^\//){ #explicit path requested, don't home in too, you mf.
                            if($explicit){$PATHS .= ' '.$argument}else{$PATHS = $argument; $explicit = 1}
                    }
                    else{
                            print "\nTranslating argument as extension sicking -> *$argument\n";
                            push @ext_arguments, "-iname \"*.$argument\" -o";
                    }                    
                }
            }#rof
    }
    #$PRNS = "-path '$ENV{'HOME'}/.' -o -path '$ENV{'HOME'}/.cpan'";
    if (@prn_arguments > 0){
        $PRNS = join (' ', @prn_arguments); $PRNS =~ s/ \-o$/ /;
    }
    if (@ext_arguments > 0){
        $EXTS = join (' ', @ext_arguments); $EXTS =~ s/ \-o$/ /;
    }
    push @vim_arguments, "-p" if $open_in_vim_tabs;
    push @VIM, @vim_arguments;
}
1;
__DATA__
The original of this file is from:
https://github.com/wbudic/wb-shell-scripts
It is not advised to use this utility, if from there can't compare.

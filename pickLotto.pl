#!/bin/perl

my @N=();

&pickSix for 1..28;

sub pickSix{
    $N[$_] = &uniqueRandom for 0..5;
    @N = sort {$a <=> $b} @N;
    print join(", ", @N), "\n";
}
sub uniqueRandom {
    my $num; my $l;
    do{ 
        $l=0; $num = 1 + int rand 45; 
        for (0..5){if($N[$_]==$num){$l=1;last}}
    }while($l);
return $num;
}

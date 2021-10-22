#!/bin/perl

my @N=();

for(1..18){&pickSix}

sub pickSix{
    for (0..5){$N[$_] = &uniqueRandom}
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

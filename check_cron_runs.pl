#!/usr/bin/env perl
use strict;
use warnings;
require Schedule::Cron::Events;
use POSIX qw(strftime);

my $cronlist = `crontab -l`;
foreach (split '\n', $cronlist) {
	my $cron = new Schedule::Cron::Events($_);
	if($cron){
		$cron->setCounterToNow; $cron->previousEvent;
		my $prev = strftime("%F %T", $cron->nextEvent);
		my $next = strftime("%F %T", $cron->nextEvent);

		print "$prev prev => ", $cron->commandLine, "\n";
		print "$next next\n";
	}
 }
__END__
#Requirments:
sudo cpan -i Schedule::Cron::Events
#!/usr/bin/perl
use strict;
use warnings;
use Net::Ping::External qw(ping);

my $ip;

for (my $i=1;$i<=254;$i++)
{
	$ip = "192.168.0.$i";
	print "$ip est connectée\n" if ping(hostname => $ip,timeout => 0.1);
}	


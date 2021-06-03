#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

my $fd = DateTime->new(year=>2008);
$fd = DateTime->now(time_zone => 'Europe/Paris');
print "[",$fd->dmy," ",$fd->hour,":",$fd->minute,"]";

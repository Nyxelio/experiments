#!/usr/bin/perl
use strict;
use warnings;

sub hello
{
	my($user1,$user2) = @_;
	print "$user1 remercie $user2 pour son hospitalité\n";
	return "Au revoir\n";
}

print hello("Alain","fred");

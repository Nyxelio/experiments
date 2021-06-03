#!/usr/bin/perl
use strict;
use warnings;

my $point=0;
my $essai=10;
my $number;
my $rand;

$rand = int rand 100;

	print "#########################################\n";
	print "#############Nombre Mystère##############\n";
	print "#########################################\n\n";
	print "Vous avez $essai essais pour deviner un nombre entre 0 et 99 inclus.\n";
		
while($essai > 0)
{
	print "Saisissez un nombre:";
	chomp($number = <STDIN>);
	$essai--;
		
	if($number < $rand)
	{
		print "\nTrop petit.";
	}
	
	if($number > $rand)
	{
		print "\nTrop grand.";
	}
	
	if($number == $rand)
	{
		print "\nBravo tu as gagné !!\n";
		exit;
	}
	else
	{
		print "Il te reste $essai essais\n";
	}
}

print "Au revoir et à bientôt\n";


#!/usr/bin/perl
use strict;
use warnings;

my %dj = (
	"Nom" => "Solveig",
	"Prenom" => "Martin",
	"Pays" => "France"
);
		  
print "$dj{Prenom} $dj{Nom} est en $dj{Pays}\n";

$dj{Salaire} = 1000;
print "Son salaire est de $dj{Salaire}\n";

foreach (keys %dj)
{
	print "$_ -> $dj{$_}\n";
}

while(my ($key,$value) = each %dj)
{
	print "$key - $value\n";
}

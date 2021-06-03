#!/usr/bin/perl
use strict;
use warnings;

open my $filehandle,">>","accesDisque.txt" or die "Problème d'ouverture:$!\n";
print $filehandle "HeLlO WoRlD\n";
print $filehandle "Un grand bonjour de France\n";
print $filehandle "n'est ce pas que c'est bien ??\n";
close $filehandle;

open $filehandle, "<", "accesDisque.txt" or die "Problème d'ouverture:$!\n";
my @text = <$filehandle>;
print "Dans mon fichier il y a :\n";
print @text;

close $filehandle;

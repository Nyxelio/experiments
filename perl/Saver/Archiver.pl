#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Archiver.pl
#
#        USAGE:  ./Archiver.pl 
#
#  DESCRIPTION:  Ce script permet d'archiver et de compresser le 
#  				 contenu du répertoire courant.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [nyxelio]
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  23.06.2008 18:55:18 CEST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Archive::Tar;

sub lister;

#my $archive = Archive::Tar->new;

print join ":", lister("./Php/");

#$archive->write("backupFTP.tar.gz",2);

sub lister
{
	my $chemin = shift;
	opendir (my $dir, $chemin);
	my @list = readdir $dir;

	print join ">", @list;

	foreach (@list)
	{ 	
		if (-d $_)
		{
			print "Répertoire: ", $_, "\n";
			if (($_ ne ".") && ($_ ne ".."))
			{
				$chemin = join "",$chemin, $_, "/";
				print "[",$chemin,"]";
				@list = lister($chemin);
			}
		}
		else
		{
			print "(",$_,")", "\n";
		}
	}
	return @list;
}

#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Saver.pl
#
#        USAGE:  ./Saver.pl 
#
#  DESCRIPTION:  Script pour faire un backup des données contenues				   sur un ftp. Les données sont sauvegardées dans le				 répertoire courant. A utiliser en adéquation avec				   le script Archiver.pl pour obtenir une archive
#  				 compressée des données.
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [Datenshi]
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  23.06.2008 12:03:21 CEST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Net::FTP::Recursive;

my $ftp = Net::FTP::Recursive->new("ftpperso.free.fr", Debug => 1)
 or die "Connexion impossible: $@";

$ftp->login("n.procureur","overlord")
 or die "Authentification impossible: ", $ftp->message;

$ftp->cwd("/creations")
 or die "Accès au répertoire impossible: ", $ftp->message;

$ftp->rget;
$ftp->quit;



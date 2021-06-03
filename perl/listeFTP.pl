#!/usr/bin/perl
use strict;
use Getopt::Long;
use Net::FTP;
use Term::ReadPassword;

my($host,$user) = ("82.254.15.188","datenshi33");
#my $password = read_password("Password:");
my $password = ""; #Password supprimé

open my $fd, ">","ftp.log" or die "Erreur ouverture fichier: $!\n";
my $ftp = Net::FTP->new($host,Debug => 0) or die "Erreur de connexion: $!\n";

$ftp->login($user,$password) or die "Erreur de login: ",$ftp->message;
print $ftp->message;

	
#$ftp->cwd("upload") or die "Erreur changement rep: ",$ftp->message; #change répertoire
#print $ftp->message;

recursivDir();
$ftp->quit;
print $ftp->message;

sub recursivDir
{
	
	print $fd "dossier ",$ftp->pwd(),":\n";
	
	my @list = $ftp->ls;
	print $ftp->message;
	#print scalar @list . " éléments dans ce répertoire\n";
	
	#print join ("\n", @list) . "\n";
	foreach (@list)
	{
		recursivDir() if ($ftp->cwd($_));
		print $fd "$_\n";	
		
	}		
}

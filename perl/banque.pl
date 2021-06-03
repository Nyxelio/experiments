#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  banque.pl
#
#        USAGE:  ./banque.pl 
#
#  DESCRIPTION:  Script pour récupérer les infos de la banque. 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Datenshi
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  18.06.2008 14:21:10 CEST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use WWW::Mechanize;
use Term::ReadPassword;
use HTML::TreeBuilder;
use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

$|++; #AutoFlush

print "Initialisation...";
my $m = WWW::Mechanize->new;

unless ($m)
{
	print RED "[ECHEC]\n";
	die "$!";
}

print GREEN "[OK]\n";

$m->get("https://www.labanquepostale.fr/identification/_ident_portail.html");

print "Connexion au site de la banque...";
unless ($m->success)
{
	print RED "[ECHEC]\n";
	die $m->res->status_line;
}

print GREEN "[OK]\n";

my $ident;
my $password;

if (@ARGV)
{
	$ident = shift;
	$password = shift;
}
else
{
	print "Saisie des identifiants:\n";
   
   	until ( $ident )
	{	
		print "Identifiant: ";
		chomp ( $ident = <STDIN> );
		redo if ( length($ident) != 10 ) ;
	}

	until ( $password )
	{
		$password = read_password ( "Mot de passe: ");
		redo unless $password;
	}
}

print "Recuperation des informations de votre compte...";

#$m->set_fields(ident => $ident);
#$m->submit();

#$m->set_fields(password => $password);
#$m->submit();

#$m->follow_link(n => 1);
#$m->follow_link(url => "../authentification/liste_contrat_atos.ea" );
#$m->follow_link(url => "liste_comptes.jsp" );

print GREEN "[OK]\n";

#open my $file, ">", "page.html" or die "Probleme";
#print $file $m->res->content;
#close $file;

#---Parsing de la page contenant les infos---#

#my $tree = HTML::TreeBuilder->new_from_content($m->res->content);

#Pour les tests:
my $tree = HTML::TreeBuilder->new;
$tree->parse_file('page.html');
# !

for ($tree->look_down(_tag => 'a', class => 'lienlibelleb'))
{
	print $_->as_trimmed_text, "\n" unless $_->as_trimmed_text eq "Mot de passe"; 
}	

for ($tree->look_down(_tag => 'span', class => 'donnes'))
{
	print $_->as_trimmed_text, "\n";
}



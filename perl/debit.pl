#!/usr/bin/perl
use strict;
use warnings;
use WWW::Mechanize;
use DateTime;

my $m = WWW::Mechanize->new(autocheck => 1);

# n�cessaire pour �viter que Free filtre selon les navigateurs
$m->agent_alias( 'Linux Mozilla' );
$m->get('http://tdebit.proxad.net/debit/index.pl');
$m->click('ok');
my @data = $m->content =~ m{
							Taille\ du\ fichier\ (\d+(?:,\d+)?\ (k|M)o).*?
							Dur�e\ (\d+(?:\.\d+)?\ secondes).*?
							D�bit\ (\d+(?:,\d+)?\ kbit/s).*?
							\((\d+(?:,\d+)?\ ko/s)\)
							}gsx;

#datetime
my $dt = DateTime->new(year => 2008);
$dt = DateTime->now(time_zone => 'Europe/Paris');
	
open my $fd,">>","./debit.log" or die "Probl�me ouverture fichier\n";

 							
my $i=0;
for (qw(descendant montant))
{
	print $fd "[",$dt->dmy," ",$dt->hour,":",$dt->minute,"] ";
	print $fd "Debit $_: ",
		  "$data[$i+3] ($data[$i+4]) | ",
		  "$data[$i] en $data[$i+2]\n";
	
	$i += 5;
}

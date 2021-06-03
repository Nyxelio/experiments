#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Selene.pl
#
#        USAGE:  ./Selene.pl 
#
#  DESCRIPTION: Le cerveau de Selene. Toutes données sont recueillies et retransmises à partir de ce script 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [Datenshi], <datenshi33@gmail.com>
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  15/06/2011 11:04:08 CEST
#     REVISION:  ---
#===============================================================================

use Net::Twitter::OAuth;
use Device::SerialPort;
use Switch;
use DateTime;

#Connexion vers Twitter
my $client = Net::Twitter::OAuth->new(
    consumer_key => "AaLiTzRxVcJVnQLiwycgg",
    consumer_secret => "TcmEPikdr3hJHMfIChfeIOj82p235F4yNFl7qtImzQ",
    access_token => "56331061-ryea5XHyS62liuX1bpM2ukD8JPi2C68AOD8TPP6w",
    access_token_secret => "7aPye4c5KlyuoLoc4qDSx6BwI3wiJvKcpR6MSAdEI",
);

#Initialisation du Serial
#9600,81N, usb
my $port = Device::SerialPort->new("/dev/ttyACM0") or die "erreur";
$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);

#Message de bienvenue
print "Bienvenue sur le monitoring de Selene\n";

my $manuel;

while(1)
{
	#####PARTIE INTERACTION DEPUIS ARDUINO#####

	$manuel = 0;

	#Donnees provenant du port serie
	my $char = $port->lookfor();
	
	print "123:".$char;
	print "\n";

	if($char != "")
	{
		print "reçu depuis arduino: "+$char;
		print "\n";

		switch($char)
		{
			case "0"
			{
				my $nouveauStatut = &activeAlarme($manuel);
				&MiseAJourStatutTwitter($client,$nouveauStatut);
			}

			case "1"
			{
				my $nouveauStatut = &desactiveAlarme($manuel);
				&MiseAJourStatutTwitter($client,$nouveauStatut);
			}

			case "2"
			{
				my $nouveauStatut = &declencheAlarme($manuel);
				&MiseAJourStatutTwitter($client,$nouveauStatut);
			}

			case "3" 
			{
				my $nouveauStatut = &arreteAlarme($manuel);
				&MiseAJourStatutTwitter($client,$nouveauStatut);
			}

			case "4"
			{
				my $nouveauStatut = &statutAlarme($manuel);
				&MiseAJourStatutTwitter($client,$nouveauStatut);
			}
			else
			{
				print "Aucune correspondance !";
			}
		}
	}

	#####PARTIE INTERACTION DEPUIS TWITTER####
	
	$manuel = 1;

	#Lecture des éventuels ordres provenant du compte twitter
	my $statuses = $client->user_timeline();
	my @statuses = @$statuses;
	$status = @statuses[0];
	
	@keyword = split(/ /,$status->{text});

	switch($keyword[0])
	{
		case "#Active"
	   	{
		   	my $nouveauStatut = &activeAlarme($manuel,$port);
		   	&MiseAJourStatutTwitter($client,$nouveauStatut);
	   	}

		case "#Desactive"
		{
		   	my $nouveauStatut = &desactiveAlarme($manuel,$port);
		   	&MiseAJourStatutTwitter($client,$nouveauStatut);
	   	}

		case "#Mode"
		{
		   	my $nouveauStatut = &declencheAlarme($manuel,$port);
		   	&MiseAJourStatutTwitter($client,$nouveauStatut);
	   	}

		case "#Fin" 
		{
		   	my $nouveauStatut = &arreteAlarme($manuel,$port);
		   	&MiseAJourStatutTwitter($client,$nouveauStatut);
	   	}

		case "#Statut"
		{
		   	my $nouveauStatut = &statutAlarme($manuel,$port);
		   	&MiseAJourStatutTwitter($client,$nouveauStatut);
	   	}
		case "#Ack" { print "Attente de nouveaux ordres...\n"; }
		else { print "Attente de nouveaux ordres...\n"; }
	}


	#Pour éviter le flood sur twitter
	sleep(15);
}

sub activeAlarme()
{
	my $manuel;
	$manuel = $_[0];

	my $port = $_[1];

	print "Activation de l'alarme";

	my $nouveauStatut;

	if($manuel)
	{
		#ecrire sur port serie pour activation
		$port->write("0");
	
		#attente activation effectuee
		#A FAIRE ??
	}

	#Preparation du nouveau statut	
	$nouveauStatut = "Selene: L'alarme est activee ".DateTime->now(time_zone => 'Europe/Paris');

	print "......Fait\n";

	return $nouveauStatut;

}

sub desactiveAlarme()
{
	my $manuel;
	$manuel = $_[0];

	my $port = $_[1];
	print "Desactivation de l'alarme";

	my $nouveauStatut;

	if($manuel)
	{
		#ecrire sur port serie pour desactivation
		#A FAIRE
		$port->write("1");

		#attente desactivation effectuee
		#A FAIRE ??
	}

	#Preparation du nouveau statut	
	$nouveauStatut = "Selene: L'alarme est desactivee ".DateTime->now(time_zone => 'Europe/Paris');

	print "......Fait\n";

	return $nouveauStatut;

}


sub declencheAlarme()
{
	my $manuel;
	$manuel = $_[0];

	my $port = $_[1];
	print "Declenchement de l'alarme";

	my $nouveauStatut;

	if($manuel)
	{

		#ecrire sur port serie pour declenchement 
		#A FAIRE
		$port->write("2");	
	
		#attente declenchement effectuee + Zones
		#A FAIRE ??
	}

	#Preparation du nouveau statut	
	$nouveauStatut = "Selene: L'alarme s'est declenchee ".DateTime->now(time_zone => 'Europe/Paris');

	print "......Fait\n";

	return $nouveauStatut;

}


sub arreteAlarme()
{
	my $manuel;
	$manuel = $_[0];

	my $port = $_[1];
	print "Arret de l'alarme";

	my $nouveauStatut;
	
	if($manuel)
	{
		#ecrire sur port serie pour arret 
		#A FAIRE
		$port->write("3");

		#attente arret effectuee
		#A FAIRE
	}

	#Preparation du nouveau statut	
	$nouveauStatut = "Selene: L'alarme s'est arretee ".DateTime->now(time_zone => 'Europe/Paris');

	print "......Fait\n";

	return $nouveauStatut;

}


sub statutAlarme()
{
	my $manuel;
	$manuel = $_[0];

	my $port = $_[1];
	print "Statut de l'alarme";

	my $nouveauStatut;
	
	if($manuel)
	{
		#ecrire sur port serie pour statut 
		#A FAIRE
		$port->write("4");

		#attente retour statut 
		#A FAIRE
	}

	#Preparation du nouveau statut	
	$nouveauStatut = "Selene: Toutes les zones sont activees / desactivees ".DateTime->now(time_zone => 'Europe/Paris');

	print "......Fait\n";

	return $nouveauStatut;

}


sub MiseAJourStatutTwitter()
{
	my $client = $_[0];
	my $tweet = $_[1];

	$client->update({ status => $tweet });

	#sleep(30);
	
	$tweet = "#Ack C'est fait ".DateTime->now(time_zone => 'Europe/Paris');

	$client->update({ status => $tweet });

}

#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  Phantom-WebServer.pl
#
#        USAGE:  ./Phantom-WebServer.pl 
#
#  DESCRIPTION: Le Serveur du Projet Phantom. Toutes données sont recueillies et retransmises à partir de ce script 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [Datenshi], <datenshi33@gmail.com>
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  03/03/2012 20:10:08 CEST
#     REVISION:  ---
#===============================================================================

use Device::SerialPort;
use Switch;
#use Term::ReadKey;

#Initialisation du Serial
#9600,81N, usb
#my $port = Device::SerialPort->new("/dev/ttyACM0") or die "erreur";
#$port->databits(8);
#$port->baudrate(9600);
#$port->parity("none");
#$port->stopbits(1);

#Message de bienvenue
print "Bienvenue sur le Serveur de Phantom\n";

#while(1)
#{
	#PARTIE ENVOI VERS ARDUINO

#	ReadMode 4; # Turn off controls keys
	
#	while (not defined ($key = ReadKey(-1)))
# 	{
	        # No key yet
#	}
	
#	print "Get key $key\n";
	
#	ReadMode 0; # Reset tty mode before exiting
#}

print "Saisie clavier:\n";
$key = <STDIN>;
print ">".$key."\n";


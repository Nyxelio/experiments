#include <iostream>
#include "testusb.h"
#include <stdio.h>
#include <string>
#include <usb.h>
#include <fstream>

using namespace std;

int main()
{
	int send_status;
	int open_status;
	unsigned char send_data=0xff;
	unsigned char receive_data=0;
	usb myusb;
	myusb.driver_init();	
	myusb.usb_scan();
	myusb.ecrire("Test.txt");
  return 0;
}


usb::usb(){}

usb::~usb(){}

void usb::driver_init()
{
	usb_init();	//Initialisation de la librairie (par example determine le chemin du repertoire des bus et peripheriques)
	usb_find_busses(); // Enumère tous les bus USB du systemes
	usb_find_devices();// Enumère tous les peripheriques sur tous les Bus présents)
 	// Parcours de la liste des bus et des périphériques
 	cout << "OK" << endl;
}

void usb::usb_scan(void)
{
	struct usb_bus *bus;
	struct usb_device *dev;
	
	for (bus = usb_busses; bus; bus = bus->next)
	{
		for (dev = bus->devices; dev; dev = dev->next)	
		{	
		printf("bus : %s  Device %s \n id Vendor: %d |  id Product : %d | Manufacturer Name :  | Product Name :  \n", bus->dirname,dev->filename ,dev->descriptor.idVendor,dev->descriptor.idProduct); // dev->descriptor.iManufacturer,dev->descriptor.iProduct ( Vous pouvez ajouter ces infos mais si les périphériques n'ont pas fournit au système les info il y aura erreur de segmentation
		}
	}
}

void usb::ecrire(const string& nom)
{
	ofstream fd;
	nomFichier = nom.c_str();
	fd.open(nom.c_str(),fstream::app);
	fd << "Hello" << endl;
	fd.close();	
}	

/*
 * Main 
 *
 * Written by:
 * Copyright 2006, Yasmin  OROU GUIDOU <ogyasmin@yahoo.fr>
 *
 * USB 
 */
#include <stdio.h>
#include <usb.h>
#include <errno.h>  // Bibliothèque des erreurs.
struct usb_bus *busses;
struct usb_bus *bus;
struct usb_device *dev,*fdev;
usb_dev_handle *device_handle = 0;
void driver_init(void)
{
	usb_init();	//Initialisation de la librairie (par example determine le chemin du repertoire des bus et peripheriques)
	usb_find_busses(); // Enumère tous les bus USB du systemes
	usb_find_devices();// Enumère tous les peripheriques sur tous les Bus présents)
 	// Parcours de la liste des bus et des périphériques
}
void usb_scan(void)
{
	for (bus = usb_busses; bus; bus = bus->next)
	{
		for (dev = bus->devices; dev; dev = dev->next)	
		{	
		printf("bus : %s  Device %s \n id Vendor: %d |  id Product : %d | Manufacturer Name :  | Product Name :  \n", bus->dirname,dev->filename ,dev->descriptor.idVendor,dev->descriptor.idProduct); // dev->descriptor.iManufacturer,dev->descriptor.iProduct ( Vous pouvez ajouter ces infos mais si les périphériques n'ont pas fournit au système les info il y aura erreur de segmentation
		}
	}
}	
struct usb_device *usb_find_My_device(int idV, int idP)
{
	for (bus = usb_busses; bus; bus = bus->next)
	{
		for (dev = bus->devices; dev; dev = dev->next)	
		{	
			// condition vérifié si c'est un Mon flash disque iProduct=Flash Disk
			if ((dev->descriptor.idVendor == idV) && (dev->descriptor.idProduct ==idP ))	//Caract de ma clé USB32 idV=0x0ea0 idP=0x2168
				return(dev);
		}
	}
	return(0);
}	
int main (void)
{
	int send_status;
	int open_status;
	unsigned char send_data=0xff;
	unsigned char receive_data=0;
	driver_init();	
	usb_scan();
  return 0;
}

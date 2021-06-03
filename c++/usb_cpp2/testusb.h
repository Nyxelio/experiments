#include <iostream>
#include <stdio.h>
#include <string>
#include <usb.h>

using namespace std;

class usb
{
	public:
			usb();
			~usb();
			void driver_init();
			void usb_scan();
			void ecrire(const string& nom);
	private:
			string nomFichier;
};


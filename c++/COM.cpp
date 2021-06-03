#include <iostream>
#include "COM.h"

using namespace std;

COM::COM()
{	vitesse = 0;
	parite = 0;
	nbBitsDonnees = 0;
}

COM::~COM()
{}

void COM::initialiser(unsigned int vit=0, unsigned char par=0,unsigned char nb=0){
	vitesse = vit;
	parite = par;
	nbBitsDonnees = nb;
}

void COM::afficher()
{
	cout << "Vitesse: " << vitesse << "Parité: " << parite << "nbBitsDonnees: " << nbBitsDonnees << endl;
}

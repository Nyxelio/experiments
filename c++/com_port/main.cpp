#include <iostream>
#include "COM.h"
using namespace std;

int main()
{
	COM com;
	com.initialiser(9600,0,8);
	com.afficher();
	return 0;
}

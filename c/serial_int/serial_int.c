#include <signal.h>
#include <sys/types.h>
#include <termios.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define BAUDRATE_DEFAUT B38400
#define MODEMDEVICE_DEFAUT "/dev/ttyS0"
#define _POSIX_SOURCE 1
#define FALSE 0
#define TRUE 1
#define TAILLE_BUF 2048 
#define TAILLE_A_LIRE 255
#define TAILLE_TABPROD 32

unsigned int fixer_baudrate(char *);
void signal_handler_IO(); //le gestionnaire de signal
void signal_handler_INT();
void creer(); //initialisation des pointeurs
int produire(); //stockage infos
int consommer(); //utilisation infos

int wait_flag = TRUE; //TRUE tant que reçu aucun signal IO
int stop_flag = FALSE; //FALSE tant que reçu aucun signal INT
int fd;
char buf[TAILLE_BUF]; //Buffer de stockage des données
unsigned int tabProd[TAILLE_TABPROD]; //Buffer indices de stockage du producteur

typedef struct
{
	unsigned int producteur;
	unsigned int consommateur;
	unsigned int tete;
	unsigned int fin;
}circ;
circ indbuf,indtabProd;

int main(int argc, char *argv[])
{
	int c;
	int err_flag=0;
	char modemdevice[11];
	unsigned int baudrate;
	struct termios oldtio, newtio;
	struct sigaction saio; //definition de l'action du signal
	
	switch(argc)
	{
		case 2:if (!strcmp(argv[1],"-h") || !strcmp(argv[1],"--help"))
				{
					printf("Usage: %s [-h|--help] [-p PORT|--port PORT] [-b VITESSE|--baudrate VITESSE]\n\n",argv[0]);
					printf("-p, --port PORT\t\tutiliser le périphérique spécifié au lieu de /dev/ttyS0\n");
					printf("-b, --baurate VITESSE\tutiliser la vitesse spécifiée au lieu de 38400\n");
					printf("-h, --help\t\tafficher cet aide-mémoire\n");
					err_flag = 1;
				}
				else
				{
					err_flag = 1;
				}
				break;
				
		case 3:if (!strcmp(argv[1],"-p") || !strcmp(argv[1],"--port"))
				{
					strcpy(modemdevice,argv[2]);
					baudrate = BAUDRATE_DEFAUT;
				}
				else if (!strcmp(argv[1],"-b") || !strcmp(argv[1],"--baudrate"))
				{
					strcpy(modemdevice,MODEMDEVICE_DEFAUT);
					
					baudrate = fixer_baudrate(argv[2]);
				}	
				else
				{
					err_flag = 1;			
				}
				break;
				
		case 5:if ((!strcmp(argv[1],"-p") || !strcmp(argv[1],"--port")) && (!strcmp(argv[3],"-b") || !strcmp(argv[3],"--baudrate")))
				{
					strcpy(modemdevice,argv[2]);
					baudrate = fixer_baudrate(argv[4]);
				}
				else if ((!strcmp(argv[3],"-p") || !strcmp(argv[3],"--port")) && (!strcmp(argv[1],"-b") || !strcmp(argv[1],"--baudrate")))
				{
					strcpy(modemdevice,argv[4]);
					baudrate = fixer_baudrate(argv[2]);
				}	
				else
				{
					err_flag = 1;			
				}
				break;
				
		default:strcpy(modemdevice,MODEMDEVICE_DEFAUT);
			    baudrate = BAUDRATE_DEFAUT;
			    break;
	}

	if(!err_flag)
	{
	printf("------------Debut de l'initialisation--------------\n");
	
	//ouvre port en mode non-bloquant (read retourne immediatement)
	fd = open(modemdevice, O_RDWR | O_NOCTTY | O_NONBLOCK);
	if (fd < 0) {perror(modemdevice); exit(-1); }
	
	printf("Le port %s a ete correctement ouvert @ %d\n",modemdevice,baudrate);
	
	//installe gestionnaire de signal puis passer port en asynchrone
	saio.sa_handler = signal_handler_IO;	
	saio.sa_flags = 0;
	saio.sa_restorer = NULL;

	if(sigaction(SIGIO,&saio,NULL) < 0){perror("sigaction");}
	if(signal(SIGINT,signal_handler_INT) < 0){perror("signal");} //installation de fonction

	printf("L'installation des gestionnaires de signaux a ete faite\n");
	
	//permet au processus de recevoir un SiGIO
	if(fcntl(fd, F_SETOWN, getpid()) < 0){perror("fcntl");}
	
	//rend le descripteur de fichier asynchrone 
	if(fcntl(fd, F_SETFL, FASYNC) < 0){perror("fcntl");}
	printf("La configuration du port %s a ete faite\n",modemdevice);

	if(tcgetattr(fd, &oldtio) < 0){perror("tcgetattr");} //sauv de la configuration courante
	
	//positionne les nouvelles valeurs pour lecture canonique
	newtio.c_cflag = baudrate | CS8 | CLOCAL | CREAD; //pas CRTSCTS
	newtio.c_iflag = IGNPAR | ICRNL;
	newtio.c_oflag = 0;
	newtio.c_lflag = ICANON;
	newtio.c_cc[VMIN] = 1;
	newtio.c_cc[VTIME] = 0;
	
	if(tcflush(fd, TCIFLUSH) < 0){perror("tcflush");}
	if(tcsetattr(fd,TCSANOW, &newtio) < 0){perror("tcsetattr");}
	
	creer();
	printf("------------Fin de l'initialisation--------------\n");
	printf("Ctrl+C pour arreter le programme\n");
	
	//on boucle en attente de lecture
	while(stop_flag == FALSE)
	{
		//printf(".\n");
		usleep(100000);
		
		//si donnees disponibles
		if(wait_flag ==FALSE)
		{
			consommer();
			//printf("%s:%d\n",buf,res);
			wait_flag = TRUE; //attend de nouvelles donnees
		}
	}
	
	//anciens parametres
	if (!tcsetattr(fd,TCSANOW,&oldtio)){perror("Retablissement");}
	close(fd);
	usleep(100);
	}
	return 0;
}

void signal_handler_IO()
{	
	produire();
	wait_flag = FALSE;
}

void signal_handler_INT()
{
	stop_flag = TRUE;
}

unsigned int fixer_baudrate(char *s)
{
	unsigned int baudrate;
	switch(atoi(s))
	{
		case 1200:baudrate=B1200;
					break;
					
		case 9600:baudrate=B9600;
					break;
					
		case 19200:baudrate=B19200;
					break;
					
		case 38400:baudrate=B38400;
					break;
					
		case 115200:baudrate=B115200;
					break;			
					
		case 230400:baudrate=B230400;
					break;			
	}
	return baudrate;
}
void creer()
{
	indbuf.producteur=0;
	indbuf.consommateur=0;
	indbuf.tete=0;
	indbuf.fin=TAILLE_BUF-1;
	
	indtabProd.producteur=0;
	indtabProd.consommateur=0;
	indtabProd.tete=0;
	indtabProd.fin=TAILLE_TABPROD-1;
}	


int produire()
{
	int nbChar,i;
	
	if( (indbuf.producteur + TAILLE_A_LIRE) > indbuf.fin)
	{ 
		printf("zero\n");
		indbuf.producteur = indbuf.tete;
	}

	printf("passe\n");
	nbChar = read(fd,&buf[indbuf.producteur],TAILLE_A_LIRE);
	
	printf("Interrupt: %d donnees recues\n",nbChar);

	if(nbChar > 0)
	{	
		
		if ((indtabProd.producteur + 1) > (indtabProd.fin))
		{
			printf("zero_tabprod\n");
			indtabProd.producteur = indtabProd.tete;
		}
		printf("passe2\n");
		tabProd[indtabProd.producteur] = indbuf.producteur;	
		printf("indbuf.producteur:%d\n",indbuf.producteur);
		printf("tabProd[indtabProd.producteur]:%d\n",tabProd[indtabProd.producteur]);

		//donnees brut pour verif. d'ici....
		for (i = 0; i < nbChar;i++)
		{
			printf("%x",buf[indbuf.producteur+i]);
		}

		printf("\n");
		//....à ici
		
		indtabProd.producteur += 1;
		indbuf.producteur += nbChar;
		tabProd[indtabProd.producteur] = indbuf.producteur;
		printf("passe3\n");
		
		printf("indbuf.producteur:%d\n",indbuf.producteur);
		printf("tabProd[indtabProd.producteur]:%d\n",tabProd[indtabProd.producteur]);
	}
	
	return 0;
}

int consommer()
{
	int nbChar = -1;
	int i;

	if(indtabProd.consommateur != indtabProd.producteur)
	{
		printf("passe4\n");
		indbuf.consommateur = tabProd[indtabProd.consommateur];
		printf("indbuf.consommateur:%d\n",indbuf.consommateur);	
		printf("passe5\n");
		
		printf("indtabProd.consommateur:%d\n",indtabProd.consommateur);
		

		
		printf("nbChar0:%d\n",nbChar);
	
			nbChar = tabProd[indtabProd.consommateur+1] - tabProd[indtabProd.consommateur];
			printf("passe6\n");

		if(nbChar < 0)
		{
			indtabProd.consommateur += 1;
			nbChar = tabProd[indtabProd.consommateur+1] - tabProd[indtabProd.consommateur];
		}
			
			printf("nbChar:%d\n",nbChar);
			printf("passe7\n");
		
		indbuf.consommateur = tabProd[indtabProd.consommateur];
		
			for(i = 0;i<nbChar;i++)
			{		
				printf("%x\n",buf[indbuf.consommateur+i]);
			}
			
		printf("\n");
		indtabProd.consommateur += 1;	
	}
	
	return 0;
}


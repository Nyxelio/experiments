#include <signal.h>
#include <sys/types.h>
#include <termios.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

#define BAUDRATE B230400
#define MODEMDEVICE "/dev/ttyS0"
#define _POSIX_SOURCE 1
#define FALSE 0
#define TRUE 1
#define TAILLE_BUF 1024
#define TAILLE_A_LIRE 255

volatile int STOP=FALSE;

void signal_handler_IO(int status); //le gestionnaire de signal
void signal_handler_INT();

int produire();
int wait_flag = TRUE; //TRUE tant que reçu aucun signal
int stop_flag = FALSE;
int stata;
int fd;
int res = 0;
char buf[TAILLE_BUF];
char *pproducteur = buf;
char *pconsommateur = buf;

main()
{
	int c;
	struct termios oldtio, newtio;
	struct sigaction saio; //definition de l'action du signal
	
	//ouvre port en mode non-bloquant (read retourne immediatement)
	fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY | O_NONBLOCK);
	printf("portouvert\n");
	if (fd < 0) {perror(MODEMDEVICE); exit(-1); }
	
	/*installe le gestionnaire de signal avant de passer le port en mode asynchrone*/
	saio.sa_handler = signal_handler_IO;
	saio.sa_flags = 0;
	saio.sa_restorer = NULL;
	printf("install sigaction\n");
	sigaction(SIGIO,&saio,NULL);
	signal(SIGINT,signal_handler_INT);
	
	//permet au processus de recevoir un SiGIO
	fcntl(fd, F_SETOWN, getpid());
	//rend le descripteur de fichier asynchrone 
	fcntl(fd, F_SETFL, FASYNC);
	printf("config port\n");
	
	tcgetattr(fd, &oldtio); //sauv de la configuration courante
	//positionne les nouvelles valeurs pour lecture canonique
	newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
	newtio.c_iflag = IGNPAR | ICRNL;
	newtio.c_oflag = 0;
	newtio.c_lflag = ICANON;
	newtio.c_cc[VMIN] = 1;
	newtio.c_cc[VTIME] = 0;
	
	tcflush(fd, TCIFLUSH);
	tcsetattr(fd,TCSANOW, &newtio);
	
	//on boucle en attente de lecture
	while(stop_flag == FALSE)
	{
		printf(".\n");
		usleep(1000000);
		
		//si donnees disponibles
		if(wait_flag ==FALSE)
		{
			printf("%s:%d %d \n",buf,res,stata);
			wait_flag = TRUE; //attend de nouvelles donnees
		}
	}
	
	//anciens parametres
	if (!tcsetattr(fd,TCSANOW,&oldtio)){perror("Retablissement");}
	printf("Retablissement des anciens parametres\n");
	sleep(1);
	return 0;
}

void signal_handler_IO(int status)
{	
	produire();
	wait_flag = FALSE;
}
void signal_handler_INT()
{
	stop_flag = TRUE;
}

int produire()
{
	int nbChar;
	if ((pproducteur + TAILLE_A_LIRE) > &buf[TAILLE_BUF-1]) {printf("++\n");pproducteur = buf;}
	
	printf("--\n");
	nbChar = read(fd,pproducteur,TAILLE_A_LIRE);
	if (nbChar == -1){printf("Erreur read\n");}
	pproducteur += nbChar;
	return (0);
}

int consommer()
{
	while ( pconsommateur != pproducteur )
	{
	}
}


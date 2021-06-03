#include <signal.h>
#include <linux/usb_gadget.h>
#include <sys/types.h>
#include <termios.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#define MODEMDEVICE "/dev/sda1"
#define FALSE 0
#define TRUE 1

volatile int STOP=FALSE;

void signal_handler_IO(int status); //le gestionnaire de signal
int wait_flag = TRUE; //TRUE tant que reçu aucun signal

main()
{
	int fd,c,res;
	struct sigaction saio; //definition de l'action du signal
	char buf[255];
	//ouvre port en mode non-bloquant (read retourne immediatement)
	fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY | O_NONBLOCK);
	printf("portouvert\n");
	if (fd < 0) {perror(MODEMDEVICE); exit(-1); }
	
	/*installe le gestionnaire de signal avant de passer le port en mode asynchrone*/
	saio.sa_handler = signal_handler_IO;
	saio.sa_flags = 0;
	saio.sa_restorer = NULL;
	printf("install sigactio\n");
	sigaction(SIGIO,&saio,NULL);
	
	//permet au processus de recevoir un SiGIO
	fcntl(fd, F_SETOWN, getpid());
	//rend le descripteur de fichier asynchrone 
	fcntl(fd, F_SETFL, FASYNC);
	printf("config port\n");
	
	//on boucle en attente de lecture
	while(STOP == FALSE)
	{
		printf(".\n");
		usleep(100000);
		
		//si donnees disponibles
		if(wait_flag ==FALSE)
		{
			//res = read(fd,buf,255);
			//buf[res] = 0;
			
			//printf("%s:%d\n",buf,res);
			printf("cle presente\n");
			//if(res == 1) STOP=TRUE; //stoppe la boucle si 1 seule ligne
			
			wait_flag = TRUE; //attend de nouvelles donnees
		}
	}
		
	//anciens parametres
	tcsetattr(fd,TCSANOW,&oldtio);
}

void signal_handler_IO(int status)
{
	printf("reception du signal IO\n");
	wait_flag = FALSE;
}

/*
============================================================================
Name        : zicls
Author      : Datenshi
Version     : 1.0
Copyright   : libre de droit
Description : Listage des artistes et des albums pour un dossier donné.
		Ce programme extrait les informations importantes à partir de
		l'appelation des dossiers et sous-dossiers telle qu'elle apparaît
		dans un gestionnaire de fichiers. La syntaxe de ces appelations 
		doit donc être conforme aux exigences imposées par l'auteur,
		dans le cas contraire les informations retournées par le programme
		ne seront pas exploitables.
		L'arborescence doit donc suivre le schéma suivant:(on suppose que
		le programme est lancé pour lister le répertoire 'Music')
		Music/
			Artiste1/
				Album1 [2000]/
				Album2 [2000]/
			Artiste2/
				Album1 [2000]/
		Notez que le nom de l'album est suivi d'un espace, et de l'année entre
		crochets. Si l'année vous est inconnue, remplacez-la par une suite de
		4 zéros.
============================================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <time.h>
#include "fonctions.c"
#define REP_DEFAUT "c:/cygwin/home/Fyrefauks/Music/"
#define FICHIER_DEFAUT "./zicls.txt"


//structure Artiste
struct Artiste
{
	char nomArtiste[256];
	struct Artiste *suiv ; 
	struct Album *album;
};

//structure Album
struct Album 
{
	char nomAlbum[256]; 
	char anneeAlbum[5];
	struct Album *suiv ; 
};

struct Artiste *tete = NULL;
struct Artiste *teteAlbum = NULL;

int main (int argc, char *argv[]) 
{
	char repertoire[4096];
	char fichier[4096];
	int display = 0;
	int error = 0;
	FILE* fp;

	switch(argc)
	{
		case 1:strcpy(repertoire,REP_DEFAUT);
			   strcpy(fichier,FICHIER_DEFAUT);
			   break;
		
		case 2:if (!strcmp(argv[1],"-h") || !strcmp(argv[1],"--help"))
				{
					printf("Usage: zicls [-v] [-d répertoire] [-f fichier]");
					exit(0);
				}
		
				if (!strcmp(argv[1],"-v") || !strcmp(argv[1],"--verbose"))
				{
					display = 1;
					strcpy(repertoire,REP_DEFAUT);
					strcpy(fichier,FICHIER_DEFAUT);
				}
		
				else
				{
					error = 1;
				}
				break;
				
		case 3:if (!strcmp(argv[1],"-d") || !strcmp(argv[1],"--directory"))
				{
					strcpy(repertoire,argv[2]);
					strcpy(fichier,FICHIER_DEFAUT);
				}
				else if (!strcmp(argv[1],"-f") || !strcmp(argv[1],"--file"))
				{
					strcpy(fichier,argv[2]);
					strcpy(repertoire,REP_DEFAUT);
				}	
				else
				{
					error = 1;			
				}
				break;
	
		case 4: display = 1;
				if (!strcmp(argv[2],"-d") || !strcmp(argv[2],"--directory"))
				{
					strcpy(repertoire,argv[3]);
					strcpy(fichier,FICHIER_DEFAUT);			
				}
				else if (!strcmp(argv[2],"-f") || !strcmp(argv[2],"--file"))
				{
					strcpy(fichier,argv[3]);
					strcpy(repertoire,REP_DEFAUT);
				}	
				else
				{
					error = 1;		
				}
				break;
				
		case 5:if ((!strcmp(argv[1],"-d") || !strcmp(argv[1],"--directory")) && (!strcmp(argv[3],"-f") || !strcmp(argv[3],"--file")))
				{
					strcpy(repertoire,argv[2]);
					strcpy(fichier,argv[4]);
				}
				else if ((!strcmp(argv[3],"-d") || !strcmp(argv[3],"--directory")) && (!strcmp(argv[1],"-f") || !strcmp(argv[1],"--file")))
				{
					strcpy(repertoire,argv[4]);							
					strcpy(fichier,argv[2]);			
				}	
				else
				{
					error = 1;
				}
				break;

		case 6:display = 1;
				if ((!strcmp(argv[2],"-d") || !strcmp(argv[2],"--directory")) && (!strcmp(argv[4],"-f") || !strcmp(argv[4],"--file")))
				{
					strcpy(repertoire,argv[3]);
					strcpy(fichier,argv[5]);
				}
				else if ((!strcmp(argv[4],"-d") || !strcmp(argv[4],"--directory")) && (!strcmp(argv[2],"-f") || !strcmp(argv[2],"--file")))
				{
					strcpy(repertoire,argv[5]);
					strcpy(fichier,argv[3]);					
				}	
				else
				{
					error = 1;
				}
				break;
	}
	
	if (error == 1)
	{
		fprintf(stderr,"Erreur de syntaxe. Merci de consulter l'aide (zicls -h)");
		exit(1);
	}	
	
	fp = fopen(fichier,"w");
	
	if (opendir(repertoire) == NULL) 
	{
		printf("Erreur lors de l'ouverture du dossier à lister. Merci de consulter l'aide (zicls -h)");
		exit(1);			
	}
	if (repertoire[strlen(repertoire) -1]!= '/') 
	{
		strcat(repertoire,"/");
	}
	if (fp != NULL)
	{
		findfile(repertoire);
		SauvChaine(repertoire,fp);
		fclose(fp);
		
		if (display == 1)
		{
			Afficher();
		}
		//triTab(); n'est malheureusement pas au point...

	}
	else
	{
		printf("*Erreur lors de l'ouverture du fichier de sauvegarde*\n");
	}
	return (0);
}



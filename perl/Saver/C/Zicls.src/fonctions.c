#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <time.h>
#include "fonctions.h"

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

void findfile(char dossier[4096]) 
{
	char ssdossier[4096];
	char *nomAlbum;
	char *anneeAlbum;
	struct dirent *lecture;
	struct Artiste* artisteCourant;
	int i,j;
	DIR *rep;

	rep = opendir(dossier);

	
	while ((lecture = readdir(rep))) 
	{

		i = 0;
		j = 0;
		
		if(strcmp(lecture->d_name,".") !=0 && strcmp(lecture->d_name,"..") != 0)
		{
			
			sprintf(ssdossier,"%s%s/",dossier,lecture->d_name);
			
			if (opendir(ssdossier) != NULL) 
			{
				
				for(i;(lecture->d_name[i]) != '\0';i++)
				{
					if ((lecture->d_name[i]) == '[')
					{
						j = 1;
						break;
					}
				}
				
				//si dossier courant est un artiste
				if ( j == 0)
				{
					artisteCourant = CreerMaillonArtiste(lecture->d_name);
					MettreEnFileArtiste(artisteCourant);
					teteAlbum = artisteCourant;
				}
				
				//si dossier courant est un album
				if ( j == 1)
				{
					struct Album* albumCourant;
					nomAlbum = malloc(sizeof(char[256]));
					anneeAlbum = malloc(sizeof(char[5]));
					
					
					ExtraireNomEtDate(lecture->d_name,i,nomAlbum,anneeAlbum);
					albumCourant = CreerMaillonAlbum(nomAlbum,anneeAlbum);
					
					MettreEnFileAlbum(albumCourant);
					
				}
				findfile(ssdossier);
			}
		}
	}   
	closedir(rep);

}

//Creer Un Maillon Artiste
struct Artiste *CreerMaillonArtiste(char* nomArtiste)
{	
	struct Artiste *result;
	result = (struct Artiste *)malloc(sizeof(struct Artiste));
	strcpy(result->nomArtiste,nomArtiste);
	result->album = NULL ;
	result->suiv = NULL ;
	return(result);
}

//Creer Un Maillon Album
struct Album *CreerMaillonAlbum(char* nomAlbum,char* anneeAlbum)
{	
	struct Album *result;
	result = (struct Album *)malloc(sizeof(struct Album));
	strcpy(result->nomAlbum,nomAlbum);
	strcpy(result->anneeAlbum,anneeAlbum);
	result->suiv = NULL ;
	return(result);
}

//Mettre en file les maillons Artiste
void MettreEnFileArtiste(struct Artiste *m)
{
	struct Artiste *p;
	if (tete == NULL)
	{
		tete = m;
	}
	else
	{
		p = tete;
		while(p->suiv != NULL)
		{
			p = p->suiv;
		}
		p->suiv = m;
		
	}
}

//Mettre en file les maillons Album
void MettreEnFileAlbum(struct Album *m)
{
	struct Album *p;
	if (teteAlbum->album == NULL)
	{
		teteAlbum->album = m;
	}
	else
	{
		p = teteAlbum->album;
		while(p->suiv != NULL)
		{
			p = p->suiv;
		}
		p->suiv = m;
		
	}
}

//Afficher
void Afficher()
{
	struct Artiste *p;
	struct Album *m;
	int nbreArtiste = 0,nbreAlbum = 0;
	p = tete;
	printf("Affichage de la liste:\n");	
	
	while(p->suiv != NULL)
	{	
		m = p->album;
		nbreArtiste++;
		printf("%s\n",p->nomArtiste);
		
		while( m->suiv != NULL)
		{	
			nbreAlbum++;
			printf("\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
			m = m->suiv;
		}
		
		nbreAlbum++;
		printf("\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
		p=p->suiv;
	}
	
	//derniere boucle:
	nbreArtiste++;
	m = p->album;
	printf("%s\n",p->nomArtiste);
	
	while( m->suiv != NULL)
	{	
		nbreAlbum++;
		printf("\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
		m = m->suiv;
	}
	
	nbreAlbum++;
	printf("\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
	
	printf("*Il y a %d artistes et %d albums enregistrés*\n",nbreArtiste,nbreAlbum);
	
}

//tri du tableau par  ordre alphabétique:
void triTab()
{
	struct Artiste *p,*pbufsuiv;
	struct Album *m,*n;
	
	char bufNom[256];
	char bufAnnee[5];
	struct Album *pbufAlbum,*mbufsuiv;
	
	p = tete;

	while(p->suiv != NULL)
	{	
		m = p->album;
		while( m->suiv != NULL)
		{	
			mbufsuiv = m;
			n = m->suiv;
			while( n->suiv != NULL)
			{
			
				if ( strcmp(mbufsuiv->anneeAlbum,n->anneeAlbum) > 0)
				{
					strcpy(bufNom,mbufsuiv->nomAlbum);
					strcpy(bufAnnee,mbufsuiv->anneeAlbum);
					
					strcpy(mbufsuiv->nomAlbum,n->nomAlbum);
					strcpy(mbufsuiv->anneeAlbum,n->anneeAlbum);				
					
					strcpy(n->nomAlbum,bufNom);
					strcpy(n->anneeAlbum,bufAnnee);
				}
				n = n->suiv;
			}
				if ( strcmp(mbufsuiv->anneeAlbum,n->anneeAlbum) > 0)
				{
					strcpy(bufNom,mbufsuiv->nomAlbum);
					strcpy(bufAnnee,mbufsuiv->anneeAlbum);
					
					strcpy(mbufsuiv->nomAlbum,n->nomAlbum);
					strcpy(mbufsuiv->anneeAlbum,n->anneeAlbum);				
					
					strcpy(n->nomAlbum,bufNom);
					strcpy(n->anneeAlbum,bufAnnee);
				}			
			m = m->suiv;
		} 		
		p=p->suiv;
	}
	

	//derniere boucle:
		m = p->album;
		while( m->suiv != NULL)
		{	
			mbufsuiv = m;
			n = m->suiv;
			while( n->suiv != NULL)
			{
			
				if ( strcmp(mbufsuiv->anneeAlbum,n->anneeAlbum) > 0)
				{
					strcpy(bufNom,mbufsuiv->nomAlbum);
					strcpy(bufAnnee,mbufsuiv->anneeAlbum);
					
					strcpy(mbufsuiv->nomAlbum,n->nomAlbum);
					strcpy(mbufsuiv->anneeAlbum,n->anneeAlbum);				
					
					strcpy(n->nomAlbum,bufNom);
					strcpy(n->anneeAlbum,bufAnnee);
				}
				n = n->suiv;
			}
				if ( strcmp(mbufsuiv->anneeAlbum,n->anneeAlbum) > 0)
				{
					strcpy(bufNom,mbufsuiv->nomAlbum);
					strcpy(bufAnnee,mbufsuiv->anneeAlbum);
					
					strcpy(mbufsuiv->nomAlbum,n->nomAlbum);
					strcpy(mbufsuiv->anneeAlbum,n->anneeAlbum);				
					
					strcpy(n->nomAlbum,bufNom);
					strcpy(n->anneeAlbum,bufAnnee);
				}			
			m = m->suiv;
		} 
	printf("*La liste a été triée de l'année la plus ancienne à la plus récente*\n");
}

//Sauvegarder chaine:
void SauvChaine(char *repertoire,FILE *fp)
{
	struct Artiste *p;
	struct Album *m;
	
	char buf[270];
	time_t t;
	int nbreArtiste = 0,nbreAlbum = 0;
	
	p = tete;

	fprintf(fp,"*Listage des Artistes:*\r\n\r\n");
	
	while(p->suiv != NULL)
	{	
		nbreArtiste++;
		m = p->album;

		fprintf(fp,"%s:\r\n",p->nomArtiste);
		
		while( m->suiv != NULL)
		{	
			nbreAlbum++;
			fprintf(fp,"\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
			m = m->suiv;
		}
		nbreAlbum++;
		fprintf(fp,"\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
		p=p->suiv;
	}
	
	//derniere boucle:
	nbreArtiste++;
	fprintf(fp,"%s:\r\n",p->nomArtiste);

	while( m->suiv != NULL)
	{	
		m = p->album;
		nbreAlbum++;
		fprintf(fp,"\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
		m = m->suiv;
	}
	
	nbreAlbum++;
	fprintf(fp,"\t\t\t\t%s:\t%s\r\n", m->anneeAlbum, m->nomAlbum);
	
	fprintf(fp,"\r\n*-----------------------------------------------------------*\r\n");
	fprintf(fp,"*Il y a %d artistes et %d albums enregistrés*\r\n",nbreArtiste,nbreAlbum);
	

	time(&t);
	fprintf(fp,"*Le dossier %s a été listé le %s\r\n",repertoire,ctime(&t));
	fprintf(fp,"Datenshi");

	printf("*Sauvegarde en cours...OK*\n\n");
}


void ExtraireNomEtDate(char album[256], int i,char* nomAlbum,char* anneeAlbum)
{
	int k = 0;
	if ( nomAlbum != NULL && anneeAlbum !=NULL)
	{
		strncpy(nomAlbum,album,(i-1));
		k=i+1;
		
		for(k;k <= (i+4);k++)
		{
			anneeAlbum[k -(i+1)] = album[k];
		}
		anneeAlbum[k + 1] = '\0';
	}
	else
	{
		printf("*Erreur d'allocation mémoire*");
		strcpy(nomAlbum,"Inconnu");
		strcpy(anneeAlbum,"0000");
	}
}

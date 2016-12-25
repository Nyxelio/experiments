#include "main.h"
#include <time.h>

#ifndef FONCTION_H_
#define FONCTION_H_

void sauver_liste();
void lire_liste();
void ajouter_item(gchar* recherche);
void lancer_recherche(gchar* recherche);
struct data * creer_item(gchar*);
void mettre_en_file(struct data *);
void init_treeview();
gchar* DonnerHeure();

struct _glade
{
	GtkWidget *window;
	GtkWidget *btRecherche;
	GtkWidget *tbRecherche;
	GtkWidget *btHaut;
	GtkWidget *btBas;
	GtkWidget *btSupprimer;
	GtkWidget *btEnregistrer;
	GtkWidget *tvHistorique;
	
	GtkListStore *store;
	
}glade;

struct data
{
	gchar date[15];
	gchar recherche[20];
	struct data *next;
};

#endif /*FONCTION_H_*/

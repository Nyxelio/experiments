#include "callback.h"


void on_btRecherche_clicked()
{
	gchar *recherche;
	recherche = gtk_entry_get_text(GTK_ENTRY(glade.tbRecherche));
	ajouter_item(recherche);
	lancer_recherche(recherche);
}

void on_btEnregistrer_clicked() {
	sauver_liste();
}
void on_btHaut_clicked() {}
void on_btBas_clicked() {}
void on_btSupprimer_clicked() {}
void on_window_destroy() 
{
	sauver_liste();
	gtk_main_quit();
}
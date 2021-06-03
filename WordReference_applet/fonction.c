#include "fonction.h"

struct data *tete = NULL;

void sauver_liste()
{
	struct data *item;
	
	FILE *fp;
	fp = fopen("hstrq.sauv","w");
	
	
	while(item->next != NULL)
	{
		fprintf(fp,"%s\n",item->date);
		fprintf(fp,"%s\n",item->recherche);

		item = item->next;
	}
	
	fprintf(fp,"%s\n",item->date);
	fprintf(fp,"%s\n",item->recherche);
	
}

void lire_liste()
{
	FILE *fp;
	fp = fopen("hstrq.sauv","r");
	
	struct data *item;
	
	//while()
	//{
		fread(&(item->date),15,sizeof(char),fp);
		fread(&(item->recherche),20,sizeof(char),fp);
		item = item->next;
	//}

	item->next = NULL;

	fclose(fp);
}

//void ajouter_item( gchar* recherche )
//{
//	GtkTreeIter iter;
//	struct data *item;
//
//	item = creer_item(recherche);
//	mettre_en_file(item);
//
//	gtk_list_store_clear(glade.store);
//
//	item = tete;
//
//	while (item->next != NULL)
//	{
//		gtk_list_store_prepend (glade.store, &iter);
//		gtk_list_store_set (glade.store, &iter, 0, item->date, 1, item->recherche,-1);
//		
//		item = item->next;
//	}
//	
//	gtk_list_store_prepend (glade.store, &iter);
//	gtk_list_store_set (glade.store, &iter, 0, item->date, 1, item->recherche,-1);
//	
//}

void ajouter_item( gchar* recherche )
{
	GtkTreeIter iter;
	gchar date[15];
	
	strcpy(date,"00:00:00");
	//printf("%s",DonnerHeure());
	//strcpy(item->date, DonnerHeure());
	//strcpy(item->recherche, recherche);
	
	gtk_list_store_prepend (glade.store, &iter);
	gtk_list_store_set (glade.store, &iter, 0, date, 1, recherche,-1);
			
}

struct data * creer_item(gchar* recherche)
{
	struct data *item;

	item = (struct data*) malloc(sizeof(struct data));
	//item = malloc(sizeof(struct data));
	
	strcpy(item->date,"00:00:00");
	//printf("%s",DonnerHeure());
	//strcpy(item->date, DonnerHeure());
	strcpy(item->recherche, recherche);
	item->next = NULL;
	
	return(item);
}	

void mettre_en_file(struct data *item)
{
	struct data *p;
	
	
	if (tete == NULL)
	{
		tete = item;
	}
	
	else
	{
		p = tete;
		while (p->next != NULL)
		{
			p = p->next;
		}
		p->next = item;
	}
}	
void lancer_recherche( gchar* recherche )
{}

void init_treeview()
{	
	GtkCellRenderer *renderer;
	GtkTreeViewColumn *column;
	
	glade.store = gtk_list_store_new (2, G_TYPE_STRING, G_TYPE_STRING);
	gtk_tree_view_set_model(GTK_TREE_VIEW(glade.tvHistorique),GTK_TREE_MODEL(glade.store));
	
	renderer = gtk_cell_renderer_text_new ();
	column = gtk_tree_view_column_new_with_attributes ("Date",renderer,"text",0,NULL);
	gtk_tree_view_append_column (GTK_TREE_VIEW (glade.tvHistorique), column);
	
	renderer = gtk_cell_renderer_text_new ();
	column = gtk_tree_view_column_new_with_attributes ("Historique",renderer,"text",1,NULL);                                               
	gtk_tree_view_append_column (GTK_TREE_VIEW (glade.tvHistorique), column);
	
  	gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(glade.tvHistorique),GTK_TREE_VIEW_GRID_LINES_BOTH);	
}

gchar* DonnerHeure()
{
	time_t t;
	gchar date[24], *heure;
	
	int i,j;
	time(&t);
	
	strcpy(date,ctime(&t));
	heure = malloc(10*sizeof(gchar));
	
	
	for(j = 0, i=11; i < 19; j++, i++ )
	{
		heure[j] = date[i];
	}
	heure[j] = '\0';
	return(heure);

}

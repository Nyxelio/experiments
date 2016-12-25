#include "main.h"


int main(int argc, char **argv) 
{
    GladeXML *xml;	
	
    gtk_init(&argc,&argv);


    /* load the interface */
    xml = glade_xml_new("WordReference.glade",NULL, NULL);

 	glade.window  = glade_xml_get_widget(xml, "WordReference");
 	glade.btRecherche  = glade_xml_get_widget(xml, "btRecherche");
 	glade.btEnregistrer  = glade_xml_get_widget(xml, "btEnregistrer");
 	glade.btHaut  = glade_xml_get_widget(xml, "btHaut");
 	glade.btBas = glade_xml_get_widget(xml, "btBas");
 	glade.btSupprimer  = glade_xml_get_widget(xml, "btSupprimer");
 	glade.tbRecherche  = glade_xml_get_widget(xml, "tbRecherche");
 	glade.tvHistorique  = glade_xml_get_widget(xml, "tvHistorique");
 
 	g_signal_connect ((gpointer) glade.btRecherche, "clicked",G_CALLBACK (on_btRecherche_clicked),NULL);
 	g_signal_connect ((gpointer) glade.btEnregistrer, "clicked",G_CALLBACK (on_btEnregistrer_clicked),NULL);
 	g_signal_connect ((gpointer) glade.btHaut, "clicked",G_CALLBACK (on_btHaut_clicked),NULL);
 	g_signal_connect ((gpointer) glade.btBas, "clicked",G_CALLBACK (on_btBas_clicked),NULL);
 	g_signal_connect ((gpointer) glade.btSupprimer, "clicked",G_CALLBACK (on_btSupprimer_clicked),NULL);
 	g_signal_connect ((gpointer) glade.window, "destroy",G_CALLBACK (on_window_destroy),NULL);
 	
 	/*init treeview*/
 	init_treeview();
	/* do whatever we want to with the menubar */
	gtk_widget_show_all(glade.window);

    /* start the event loop */
    gtk_main();

	return 0;
}

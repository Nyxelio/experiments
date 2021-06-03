#!/usr/bin/env python
# -*- coding: utf-8 -*-
#-----------------------------------------
#Projet: Shad-Voice-Control
#Fichier: actions.py
#Description: Gestions des actions 
#Auteur: Datenshi
#Année: 2008
#-----------------------------------------

import os
import gobject
gobject.threads_init()

class Actions(object):
    def __init__(self):
	pass

    def final_result(self,hyp,uttid):
	if hyp != "":
    	    print "La commande validée est: ",hyp
	    #p = gobject.spawn_async(['espeak -v mb/mb-fr4','\"hello\"',' | mbrola /opt/fr4/fr4 - -.au | aplay'],flags= gobject.SPAWN_SEARCH_PATH, standard_output=None)
	    
	    #Provisoire
	    if hyp == "EDITION":
		hyp = "édition"
	    if hyp == "SELECTIONNER":
		hyp = "sélectionner"

	    os.system("espeak -v mb/mb-fr4 '"+hyp+"' | mbrola /opt/fr4/fr4 - -.au | aplay")


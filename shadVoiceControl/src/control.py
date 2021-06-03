#!/usr/bin/env python
# -*- coding: utf-8 -*-
#-----------------------------------------
#Projet: Shad-Voice-Control
#Fichier: control.py
#Description: Initialisations
#Auteur: Datenshi
#Annee: 2008
#-----------------------------------------

from os import getcwd
import pygtk
pygtk.require('2.0')
import gtk

import gobject
import pygst
pygst.require('0.10')
gobject.threads_init()
import gst
from actions import *

class ShadVoiceControl:
    """Shad-voice-control"""

    def __init__(self):
        """Initialisation"""
	self.init_gui()
	self.clGst = ClGst(self)
	self.actions = Actions()

    def init_gui(self):
        """Initialisation des composants GUI"""
        self.window = gtk.Window()
        self.window.connect("delete-event", gtk.main_quit)
        self.window.set_default_size(400,200)
        self.window.set_border_width(10)
        vbox = gtk.VBox()
        self.textbuf = gtk.TextBuffer()
        self.text = gtk.TextView(self.textbuf)
        self.text.set_wrap_mode(gtk.WRAP_WORD)
        vbox.pack_start(self.text)
        self.button = gtk.ToggleButton("Speak")
        self.button.connect('clicked', self.button_clicked)
        vbox.pack_start(self.button, False, False, 5)
        self.window.add(vbox)
        self.window.show_all()
	#ici à placer les composants pour l'applet
   
    def partial_result(self, hyp, uttid):
        """Annule la selection précedente, entre le nouveau
	texte, et le sélectionne"""
        # All this stuff appears as one single action
        self.textbuf.begin_user_action()
        self.textbuf.delete_selection(True, self.text.get_editable())
        self.textbuf.insert_at_cursor(hyp)
        ins = self.textbuf.get_insert()
        iter = self.textbuf.get_iter_at_mark(ins)
        iter.backward_chars(len(hyp))
        self.textbuf.move_mark(ins, iter)
        self.textbuf.end_user_action()

    def final_result(self, hyp, uttid):
        """Insert le nouveau texte final"""
	# All this stuff appears as one single action
        self.textbuf.begin_user_action()
        self.textbuf.delete_selection(True, self.text.get_editable())
        self.textbuf.insert_at_cursor(hyp)
        self.textbuf.end_user_action()

    def button_clicked(self, button):
        """Gestion de l'état du bouton"""
        if button.get_active():
            button.set_label("Stop")
            self.clGst.pipeline.set_state(gst.STATE_PLAYING)
        else:
            button.set_label("Speak")
            self.vader = self.clGst.pipeline.get_by_name('vad')
            self.vader.set_property('silent', True)


class ClGst:

    def __init__(self,descShad):
	"""Initialisation"""
	self.pipeline = 0
	self.rep_src = getcwd()
	self.init_gst()
	self.shad = descShad
	self.actions = Actions()

    def init_gst(self):
        """Initialise les composants de reconnaissance vocale"""
        self.pipeline = gst.parse_launch('gconfaudiosrc ! audioconvert ! audioresample '
                                         + '! vader name=vad auto-threshold=true '
                                         + '! pocketsphinx name=asr ! fakesink')
        asr = self.pipeline.get_by_name('asr')
        asr.connect('partial_result', self.asr_partial_result)
        asr.connect('result', self.asr_result)
        asr.set_property('lm', self.rep_src + '/../data/7322.lm')
        asr.set_property('dict', self.rep_src + '/../data/7322.dic')

        bus = self.pipeline.get_bus()
        bus.add_signal_watch()
        bus.connect('message::application', self.application_message)

        self.pipeline.set_state(gst.STATE_PAUSED)

    def asr_partial_result(self, asr, text, uttid):
        """Fait suivre les signaux des résultats partiels vers le thread principal"""
        struct = gst.Structure('partial_result')
        struct.set_value('hyp', text)
        struct.set_value('uttid', uttid)
        asr.post_message(gst.message_new_application(asr, struct))

    def asr_result(self, asr, text, uttid):
        """Fait suivre les signaux des résulats définitifs vers le thread principal"""
        struct = gst.Structure('result')
        struct.set_value('hyp', text)
        struct.set_value('uttid', uttid)
        asr.post_message(gst.message_new_application(asr, struct))

    def application_message(self, bus, msg):
        """Reçoit les messages du bus"""
        msgtype = msg.structure.get_name()
        if msgtype == 'partial_result':
            self.shad.partial_result(msg.structure['hyp'], msg.structure['uttid'])
        elif msgtype == 'result':
            self.shad.final_result(msg.structure['hyp'], msg.structure['uttid'])
            self.pipeline.set_state(gst.STATE_PAUSED)
            self.shad.button.set_active(False)
	    self.actions.final_result(msg.structure['hyp'], msg.structure['uttid'])


###########################################
########## Programme principal ############

if __name__ == "__main__":
    ShadVoiceControl()
    gtk.main()

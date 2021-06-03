PROGS = dbusHal

$(PROGS):$(PROGS).c
	$(CC) -o dbusHal dbusHal.c `pkg-config --cflags --libs glib-2.0` -ldbus-1 -ldbus-glib-1


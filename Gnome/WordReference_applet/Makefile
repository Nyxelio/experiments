WRSearcher: main.o callback.o fonction.o
	gcc -o WRSearcher main.o callback.o fonction.o `pkg-config --cflags --libs gtk+-2.0` -lglade-2.0

main.o:	main.h main.c
	gcc -c main.c `pkg-config --cflags --libs gtk+-2.0` -lglade-2.0

callback.o:	callback.h callback.c
	gcc -c callback.c `pkg-config --cflags --libs gtk+-2.0` -lglade-2.0

fonction.o:	fonction.h fonction.c
	gcc -c fonction.c `pkg-config --cflags --libs gtk+-2.0` -lglade-2.0
sdl-rpg:main.o map.o
	gcc -o sdl-rpg main.o map.o `sdl-config --cflags` `sdl-config --libs` -lSDL_image -lfmod-3.75
		
main.o:./src/main.c ./src/main.h
	gcc -c ./src/main.c
	
map.o:./src/map.c ./src/map.h
	gcc -c ./src/map.c	

clean:
	rm -f ./src/*.o

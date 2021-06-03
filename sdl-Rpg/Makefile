sdl-Rpg:main.o map.o sprite.o events.o
	gcc -o ./bin/sdl-Rpg main.o map.o sprite.o events.o `sdl-config --cflags` `sdl-config --libs` -lSDL_image -lfmod-3.75
		
main.o:./src/main.c ./inc/main.h
	gcc -c ./src/main.c
	
map.o:./src/map.c ./inc/map.h
	gcc -c ./src/map.c	
	
sprite.o:./src/sprite.c ./inc/sprite.h
	gcc -c ./src/sprite.c	
	
events.o:./src/events.c ./inc/events.h
	gcc -c ./src/events.c	

clean:
	rm -f ./*.o

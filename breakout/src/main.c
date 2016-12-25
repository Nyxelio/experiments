/*
 * main.c
 * Copyright (C) Nyxelio 2007
 *
	main.c is free software.
	
	You may redistribute it and/or modify it under the terms of the
	GNU General Public License, as published by the Free Software
	Foundation; either version 2 of the License, or (at your option)
	any later version.
	
	main.c is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
	See the GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with main.c.  If not, write to:
		The Free Software Foundation, Inc.,
		51 Franklin Street, Fifth Floor
		Boston, MA  02110-1301, USA.
 */


#include <stdlib.h>
#include <stdio.h>
#include <SDL/SDL.h>
#include <SDL/SDL_image.h> /* Inclusion du header de SDL_image */
#include "map.h"

#define LARGEUR_FENETRE 640
#define HAUTEUR_FENETRE 480

void pause();

int main(int argc, char *argv[])
{
    SDL_Surface *ecran = NULL; // Le pointeur qui va stocker la surface de l'écran
	SDL_Surface *barre = NULL;
	SDL_Rect positionBarre;
	int continuer = 1;
	SDL_Event event;
	
    SDL_Init(SDL_INIT_VIDEO);

    ecran = SDL_SetVideoMode(640, 480, 32, SDL_HWSURFACE | SDL_DOUBLEBUF); // On tente d'ouvrir une fenêtre
    if (ecran == NULL) // Si l'ouverture a échoué, on écrit l'erreur et on arrête
    {
        fprintf(stderr, "Impossible de charger le mode vidéo : %s\nq", SDL_GetError());
        exit(EXIT_FAILURE);
    }
   
    SDL_WM_SetCaption("Arkanoid !", NULL);
	SDL_EnableKeyRepeat(10, 10);
	SDL_ShowCursor(SDL_DISABLE);
	
    /* Chargement d'un PNG avec IMG_Load
    Celui-ci est automatiquement rendu transparent car les informations de
    transparence sont codées à l'intérieur du fichier PNG */
	
    barre = IMG_Load("./img/barre.png");
	positionBarre.x = 300;
	positionBarre.y = 400;
    SDL_BlitSurface(barre, NULL, ecran, &positionBarre);
	
	SDL_Flip(ecran);
	
    while (continuer)
	{
  	 	 SDL_WaitEvent(&event);
  	 	 
    	switch(event.type)
   	 	{
     	   case SDL_QUIT:
      	      continuer = 0;
      	      break;
      	  case SDL_KEYDOWN:
      	      switch (event.key.keysym.sym)
           	 {
					case SDLK_LEFT:
							positionBarre.x-=5;
             	       break;
				
					case SDLK_RIGHT:
						if(((positionBarre.x + 1) + barre->w) < LARGEUR_FENETRE)	
							{				
								positionBarre.x+=5;
               	     		}
               	     break;
				
              	  case SDLK_ESCAPE: /* Appui sur la touche Echap, on arrête le programme */
               	     continuer = 0;
               	     break;
				
					case SDL_MOUSEBUTTONUP:
        				if (event.button.button == SDL_BUTTON_RIGHT)
        				//lancer missiles
           			 	break;
            	}
           	 break;
           	 
           	 case SDL_MOUSEMOTION:
           	 if(((event.motion.x) + barre->w) < LARGEUR_FENETRE)	
							{		
								positionBarre.x = event.motion.x; /* On change les coordonnées de Zozor */		
               	     		}
         		
          		break;
   		 	}
   		 	        // Effacement de l'écran
         SDL_FillRect(ecran, NULL, SDL_MapRGB(ecran->format, 0, 0, 0));
        
		 SDL_BlitSurface(barre, NULL, ecran, &positionBarre); /* On place zozor à sa nouvelle position */
    	 SDL_Flip(ecran);
	}

    SDL_Quit();

    return EXIT_SUCCESS;
}

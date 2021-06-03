/*
** main.c
**
** Fichier principal.
**
** Rôle:
** - initialisation et libération des librairies.
** - fonction main()
*/
   
#include "../inc/main.h"
#include "../inc/sprite.h"
 
int main(int argc, char **argv)
{
  SDL_Event event;
  struct s_map map;
  struct s_lib_sprite libsprite;
  struct s_lib_event  libevent; 
  int isdone;
  int focus=1;
  
  if(Init()>0)
  {
     return 1;
  }
  
  	 LoadMap(&map, "./data/map/01.map"); 	
  /* RandomizeMap(&map,27,20,"./data/tiles/mchip0.bmp"); 
   * SaveMap(&map, "./data/map/save.map", "./data/musique/Opening1.mid", "./data/tiles/mchip0.bmp");
   */
    
	 LoadSprite(&libsprite,"./data/map/01.sprite");
  /* InitSprite(&libsprite);
   * SpriteStaticData(&libsprite);
   * SaveSprite(&libsprite,"./data/sprites/player.bmp","./data/map/02.sprite");
   */

     //LoadEvent(&libevent,&map,&libsprite,"./data/map/02.event");	
   InitLibEvent(&libevent,&map,&libsprite);
   EventStaticData(&libevent,&map,&libsprite);
   SaveEvent(&libevent,&map,&libsprite,"./data/son/tornade.wav","../data/map/02.event");
   	

  SDL_EnableKeyRepeat(100,10);
 
  isdone=0;
  while (!isdone)
  {
    /* Lecture des évènements dans la queue d'évènements */
    while (SDL_PollEvent (&event))
    {
      MapEvent(&event, &map);
      SpriteEvent(&event, &map, &libsprite);
      Event(&event, &libevent, &map, &libsprite);

      switch (event.type)
      {
      	case SDL_KEYDOWN:
	   			 if(event.key.state==SDL_PRESSED)
	    			{
         				 if(event.key.keysym.sym==SDLK_ESCAPE)
	       					 isdone = 1;
	     				 else if (event.key.keysym.sym==SDLK_F1)
	       					 SDL_SaveBMP(SDL_GetVideoSurface(),"screenshot.bmp");
	  				}
     			 break;
     			 
     	case SDL_ACTIVEEVENT:
	   			 if(event.active.state==SDL_APPINPUTFOCUS)
	    			{
         				printf(":%d\n",event.active.gain);
         				focus = event.active.gain;
         					
	  				}
     			 break;		 
     			 
      	case SDL_QUIT:
       		     isdone = 1;
	  			 break;
      }
     }
    
    if (focus)
  	{
    HandleMap(&map);
    HandleSprites(&libsprite, &map);
    HandleEvent(&libevent, &map, &libsprite);  
  	}
  	 SDL_Flip(SDL_GetVideoSurface());
  }
  
  FreeLibEvent(&libevent, &map, &libsprite);
  FreeMap(&map);
  FreeSprite(&libsprite);
  return 0;
}
 
/*
** Initialisation du programme
*/
int Init()
{
    SDL_Surface *screen;
 
    /* Appel de Free lors de la fermeture du programme */
    atexit(Free);
 
    /* Initialisation de SDL */
    if(SDL_Init(SDL_INIT_VIDEO)==-1)
    {
       perror("Impossible d'initialiser SDL.\n");
       return 1;
    }
 
    /* Initialisation de la fenêtre */
    screen = SDL_SetVideoMode(800, 600, 32, SDL_HWSURFACE|SDL_DOUBLEBUF);
    if(screen==NULL)
    {
       perror("Erreur lors de la création de la fenêtre.\n");
       return 1;
    }
 
    /* Change le titre de la fenêtre et de l'icône */
    SDL_WM_SetCaption("RPG 2D - Games Creators Network (http://www.games-creators.org)","RPG 2d");
 
    /* Initialisation de FMOD */
    if (FSOUND_GetVersion() < FMOD_VERSION)
    {
        fprintf(stderr, "Mauvaise version de la librairie. Vous devriez utiliser la version %.02f\n", FMOD_VERSION);
        exit(1);
    }
 
    
        //INITIALIZE
    
    if (!FSOUND_Init(32000, 64, 0))
    {
        fprintf(stderr,"Erreur à l'initialisation de FMOD: %s\n", FMOD_ErrorString(FSOUND_GetError()));
        //exit(1);
    }
 	
 	
    return 0;
}
 
/*
** Libération du programme
*/
void Free()
{
    SDL_Quit();
}

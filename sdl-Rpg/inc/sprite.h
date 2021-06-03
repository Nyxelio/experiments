/*
** sprite.h
**
** Gestion des sprites
**
** Rôle:
** - initialisation et libération des sprites.
** - affichage des sprites
** - gestion des événements associés au sprites
*/
 
#ifndef SPRITE_H
# define SPRITE_H
 
# include <stdlib.h>
# include <SDL/SDL.h>
 
# include "map.h"
 


# define ANIMATION_HAUT   0
# define ANIMATION_DROITE 1
# define ANIMATION_GAUCHE 3
# define ANIMATION_BAS    2
 
 
 
struct s_lib_sprite
{
   unsigned int n_sprite;    /* nombre de sprites chargés */
   struct s_sprite *sprites; /* pointeur vers les sprites */
};
 
struct s_frame
{
   unsigned int x,y;         /* coordonnée de l'animation dans la surface */
};
 
struct s_anim
{
   unsigned int n_frame;     /* nombre de frames dans l'animation */
   unsigned int cur_frame;   /* numéro de la frame actuellement affichée */
   unsigned int lastfrmupdate; /* stocke le moment où l'animation est passée à la frame actuelle */
   unsigned int delaybetweenframes; /* délai entre deux frames */
   struct s_frame *frame;    /* pointeur vers les frames */
};
 
struct s_sprite
{
   unsigned int x,y;        /* coordonnées du sprite dans la carte */
   
   unsigned int width, height; /* taille du sprite */
 
   unsigned int n_anim;     /* nombre d'animations pour ce sprite */
   unsigned int cur_anim;   /* n° de l'animation courante */
   unsigned char ispaused_anim; /* booléen indiquant si l'animation est en pause */
   struct s_anim *anim;     /* pointeur vers les animations */
 
   unsigned int offsetG, offsetD, offsetH, offsetB; /* marges du sprite */
 
   SDL_Surface *surf;      /* pointeur vers la surface contenant le charset */
};


void InitSprite(struct s_lib_sprite *libsprite);
void FreeSprite(struct s_lib_sprite *libsprite);
void HandleSprites(struct s_lib_sprite *libsprite, struct s_map *map);
void HandleSprite(struct s_sprite *sprite, struct s_map *map);
 
void SpriteChangeAnim(struct s_sprite *sprite, unsigned int anim, unsigned char ispaused);
 
void SpriteEvent(SDL_Event *event, struct s_map *map, struct s_lib_sprite *libsprite);
 
void LoadSprite(struct s_lib_sprite *libsprite, char *filename);
void SaveSprite(struct s_lib_sprite *libsprite, char *charset, char *filename);
void SpriteMove(struct s_sprite *sprite, unsigned int x, unsigned int y, struct s_map *map);
void SpriteStaticData(struct s_lib_sprite *libsprite);
 
#endif /* !SPRITE_H_ */ 

/*
** main.h
**
** Fichier principal.
**
** Rôle:
** - fonction main()
*/
 
#ifndef MAIN_H
# define MAIN_H
 
# include <SDL/SDL.h>
 
# include <stdio.h>
# include <stdlib.h>
# include <signal.h>
 
# include "map.h"
# include "sprite.h"
# include "events.h"
 
int Init();
void Free();
 
#endif /* !MAIN_H */

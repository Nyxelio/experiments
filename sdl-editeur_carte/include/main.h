/*
** main.c
**
** Fichier principal.
**
** R�le:
** - fonction main()
*/

#ifndef MAIN_H
# define MAIN_H

# include <SDL/SDL.h>

# include <fmod/fmod.h>
# include <fmod/fmod_errors.h>

# include <stdio.h>
# include <stdlib.h>

# include "map.h"

int Init();
void Free();

#endif /* !MAIN_H */
